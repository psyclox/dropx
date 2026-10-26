import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/transfer_model.dart';
import '../models/device_model.dart';

const int kTransferPort = 49152;
const int kDiscoveryPort = 49153;
const String kAppId = 'DROPX_V1';

// ─── Providers ─────────────────────────────────────────────────────────────

final transferServiceProvider = Provider<TransferService>((ref) {
  final service = TransferService();
  ref.onDispose(() => service.dispose());
  return service;
});

final discoveryServiceProvider = Provider<DiscoveryService>((ref) {
  final service = DiscoveryService();
  ref.onDispose(() => service.dispose());
  return service;
});

final activeTransfersProvider = StateNotifierProvider<ActiveTransfersNotifier, List<TransferModel>>((ref) {
  return ActiveTransfersNotifier();
});

final discoveredDevicesProvider = StateNotifierProvider<DiscoveredDevicesNotifier, List<DeviceModel>>((ref) {
  return DiscoveredDevicesNotifier();
});

// ─── Transfer Service ───────────────────────────────────────────────────────

class TransferService {
  HttpServer? _server;
  final _uuid = const Uuid();
  
  final StreamController<TransferEvent> _eventController = 
      StreamController<TransferEvent>.broadcast();
  
  Stream<TransferEvent> get events => _eventController.stream;

  /// Start HTTP server to receive files
  Future<void> startServer({
    required Function(TransferModel) onTransferStarted,
    required Function(String, int, int) onProgress,
    required Function(String, String) onComplete,
    required Function(String, String) onError,
  }) async {
    final router = Router();
    
    // Handshake endpoint
    router.get('/ping', (Request req) {
      return Response.ok(
        jsonEncode({'status': 'ok', 'app': kAppId}),
        headers: {'Content-Type': 'application/json'},
      );
    });
    
    // File info endpoint (metadata)
    router.post('/transfer/init', (Request req) async {
      try {
        final body = await req.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        
        final transferId = _uuid.v4();
        final model = TransferModel(
          id: transferId,
          fileName: data['fileName'] as String,
          fileSize: data['fileSize'] as int,
          mimeType: data['mimeType'] as String? ?? 'application/octet-stream',
          checksum: data['checksum'] as String?,
          senderName: data['senderName'] as String? ?? 'Unknown',
          status: TransferStatus.pending,
          createdAt: DateTime.now(),
          direction: TransferDirection.receiving,
        );
        
        onTransferStarted(model);
        
        return Response.ok(
          jsonEncode({'transferId': transferId, 'accepted': true}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(body: e.toString());
      }
    });
    
    // File upload endpoint
    router.post('/transfer/<transferId>/upload', (Request req, String transferId) async {
      try {
        final downloadsDir = await _getDownloadPath();
        final fileName = req.headers['x-file-name'] ?? 'received_file';
        final fileSize = int.tryParse(req.headers['x-file-size'] ?? '0') ?? 0;
        final checksum = req.headers['x-checksum'];
        
        final filePath = p.join(downloadsDir, 'DropX', fileName);
        final file = File(filePath);
        await file.parent.create(recursive: true);
        
        final sink = file.openWrite();
        int bytesReceived = 0;
        
        await for (final chunk in req.read()) {
          sink.add(chunk);
          bytesReceived += chunk.length;
          onProgress(transferId, bytesReceived, fileSize);
        }
        
        await sink.close();
        
        // Verify checksum using streaming digest (O(1) memory usage)
        if (checksum != null) {
          final calculatedHash = (await sha256.bind(file.openRead()).first).toString();
          if (calculatedHash != checksum) {
            await file.delete();
            onError(transferId, 'Checksum mismatch - file corrupted');
            return Response.internalServerError(body: 'Checksum mismatch');
          }
        }
        
        onComplete(transferId, filePath);
        return Response.ok(jsonEncode({'success': true, 'savedPath': filePath}));
      } catch (e) {
        onError(transferId, e.toString());
        return Response.internalServerError(body: e.toString());
      }
    });

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, kTransferPort);
  }

  /// Send a file to target device
  Future<void> sendFile({
    required String filePath,
    required String targetIp,
    required String senderName,
    required TransferModel model,
    required Function(int, int) onProgress,
    required Function(String) onComplete,
    required Function(String) onError,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      onError('File not found: $filePath');
      return;
    }
    
    final fileSize = await file.length();
    // Stream-based checksum calculation for unlimited file size
    final digest = await sha256.bind(file.openRead()).first;
    final checksum = digest.toString();
    final fileName = p.basename(filePath);
    
    final client = HttpClient();
    
    try {
      // Init transfer
      final initReq = await client.post(targetIp, kTransferPort, '/transfer/init');
      initReq.headers.contentType = ContentType.json;
      initReq.write(jsonEncode({
        'fileName': fileName,
        'fileSize': fileSize,
        'mimeType': _getMimeType(fileName),
        'checksum': checksum,
        'senderName': senderName,
      }));
      
      final initRes = await initReq.close();
      final initBody = await initRes.transform(utf8.decoder).join();
      final initData = jsonDecode(initBody) as Map<String, dynamic>;
      
      if (initData['accepted'] != true) {
        onError('Transfer rejected by receiver');
        return;
      }
      
      final transferId = initData['transferId'] as String;
      
      // Upload file directly via Stream (zero memory buffering)
      final uploadReq = await client.post(targetIp, kTransferPort, '/transfer/$transferId/upload');
      uploadReq.headers.set('x-file-name', fileName);
      uploadReq.headers.set('x-file-size', fileSize.toString());
      uploadReq.headers.set('x-checksum', checksum);
      uploadReq.headers.contentType = ContentType.binary;
      uploadReq.contentLength = fileSize;
      
      int bytesSent = 0;
      await for (final chunk in file.openRead()) {
        uploadReq.add(chunk);
        bytesSent += chunk.length;
        onProgress(bytesSent, fileSize);
      }
      
      final uploadRes = await uploadReq.close();
      if (uploadRes.statusCode == 200) {
        onComplete(transferId);
      } else {
        onError('Upload failed with status: ${uploadRes.statusCode}');
      }
    } catch (e) {
      onError('Transfer failed: $e');
    } finally {
      client.close();
    }
  }
  
  /// Send multiple files
  Future<void> sendFiles({
    required List<String> filePaths,
    required String targetIp,
    required String senderName,
    required Function(String, int, int) onFileProgress,
    required Function(String) onFileComplete,
    required Function(String, String) onFileError,
    required Function() onAllComplete,
  }) async {
    for (final filePath in filePaths) {
      final fileName = p.basename(filePath);
      final file = File(filePath);
      final fileSize = await file.length();
      
      final model = TransferModel(
        id: const Uuid().v4(),
        fileName: fileName,
        fileSize: fileSize,
        mimeType: _getMimeType(fileName),
        senderName: senderName,
        status: TransferStatus.inProgress,
        createdAt: DateTime.now(),
        direction: TransferDirection.sending,
        filePath: filePath,
      );
      
      await sendFile(
        filePath: filePath,
        targetIp: targetIp,
        senderName: senderName,
        model: model,
        onProgress: (sent, total) => onFileProgress(fileName, sent, total),
        onComplete: onFileComplete,
        onError: (err) => onFileError(fileName, err),
      );
    }
    onAllComplete();
  }

  Future<String> _getDownloadPath() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download';
    } else if (Platform.isWindows) {
      final docs = await getApplicationDocumentsDirectory();
      return p.join(docs.parent.path, 'Downloads');
    }
    final docs = await getApplicationDocumentsDirectory();
    return docs.path;
  }

  String _getMimeType(String fileName) {
    final ext = p.extension(fileName).toLowerCase();
    const mimeMap = {
      '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg',
      '.png': 'image/png', '.gif': 'image/gif',
      '.webp': 'image/webp', '.heic': 'image/heic',
      '.mp4': 'video/mp4', '.mkv': 'video/x-matroska',
      '.avi': 'video/x-msvideo', '.mov': 'video/quicktime',
      '.mp3': 'audio/mpeg', '.wav': 'audio/wav',
      '.flac': 'audio/flac', '.aac': 'audio/aac',
      '.pdf': 'application/pdf',
      '.doc': 'application/msword',
      '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      '.zip': 'application/zip', '.rar': 'application/x-rar-compressed',
      '.apk': 'application/vnd.android.package-archive',
      '.exe': 'application/x-msdownload',
    };
    return mimeMap[ext] ?? 'application/octet-stream';
  }

  Future<void> stopServer() async {
    await _server?.close(force: true);
    _server = null;
  }

  void dispose() {
    stopServer();
    _eventController.close();
  }
}

// ─── Discovery Service ──────────────────────────────────────────────────────

class DiscoveryService {
  RawDatagramSocket? _socket;
  Timer? _broadcastTimer;
  final StreamController<DeviceModel> _deviceController = 
      StreamController<DeviceModel>.broadcast();
  
  Stream<DeviceModel> get discoveredDevices => _deviceController.stream;
  
  String _deviceName = 'Unknown Device';
  String _deviceId = const Uuid().v4();

  Future<void> startBroadcasting({
    required String deviceName,
    required String deviceId,
  }) async {
    _deviceName = deviceName;
    _deviceId = deviceId;
    
    _socket ??= await RawDatagramSocket.bind(InternetAddress.anyIPv4, kDiscoveryPort);
    _socket!.broadcastEnabled = true;
    
    // Listen for other devices
    _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram != null) {
          try {
            final message = utf8.decode(datagram.data);
            final data = jsonDecode(message) as Map<String, dynamic>;
            
            if (data['app'] == kAppId && data['deviceId'] != _deviceId) {
              final device = DeviceModel(
                id: data['deviceId'] as String,
                name: data['deviceName'] as String,
                ip: datagram.address.address,
                platform: data['platform'] as String? ?? 'Unknown',
                lastSeen: DateTime.now(),
              );
              _deviceController.add(device);
            }
          } catch (_) {}
        }
      }
    });
    
    // Broadcast our presence every 2 seconds
    _broadcastTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _broadcast();
    });
    _broadcast(); // Immediate first broadcast
  }

  void _broadcast() {
    if (_socket == null) return;
    
    final message = jsonEncode({
      'app': kAppId,
      'deviceId': _deviceId,
      'deviceName': _deviceName,
      'platform': Platform.operatingSystem,
      'port': kTransferPort,
    });
    
    final data = utf8.encode(message);
    _socket!.send(
      data,
      InternetAddress('255.255.255.255'),
      kDiscoveryPort,
    );
  }

  void stopBroadcasting() {
    _broadcastTimer?.cancel();
    _socket?.close();
    _socket = null;
  }

  void dispose() {
    stopBroadcasting();
    _deviceController.close();
  }
}

// ─── State Notifiers ────────────────────────────────────────────────────────

class ActiveTransfersNotifier extends StateNotifier<List<TransferModel>> {
  ActiveTransfersNotifier() : super([]);

  void add(TransferModel transfer) {
    state = [...state, transfer];
  }

  void update(String id, TransferModel updated) {
    state = state.map((t) => t.id == id ? updated : t).toList();
  }

  void updateProgress(String id, int bytesTransferred, int totalBytes) {
    final progress = totalBytes > 0 ? bytesTransferred / totalBytes : 0.0;
    final speed = bytesTransferred / 1024 / 1024; // MB/s approx
    
    state = state.map((t) {
      if (t.id == id) {
        return t.copyWith(
          progress: progress,
          bytesTransferred: bytesTransferred,
          speed: speed,
          status: TransferStatus.inProgress,
        );
      }
      return t;
    }).toList();
  }

  void complete(String id, String savedPath) {
    state = state.map((t) {
      if (t.id == id) {
        return t.copyWith(
          status: TransferStatus.completed,
          progress: 1.0,
          filePath: savedPath,
          completedAt: DateTime.now(),
        );
      }
      return t;
    }).toList();
  }

  void fail(String id, String error) {
    state = state.map((t) {
      if (t.id == id) {
        return t.copyWith(
          status: TransferStatus.failed,
          errorMessage: error,
          completedAt: DateTime.now(),
        );
      }
      return t;
    }).toList();
  }

  void cancel(String id) {
    state = state.map((t) {
      if (t.id == id) {
        return t.copyWith(status: TransferStatus.cancelled);
      }
      return t;
    }).toList();
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}

class DiscoveredDevicesNotifier extends StateNotifier<List<DeviceModel>> {
  DiscoveredDevicesNotifier() : super([]);
  Timer? _cleanupTimer;

  void addOrUpdate(DeviceModel device) {
    final existing = state.any((d) => d.id == device.id);
    if (existing) {
      state = state.map((d) => d.id == device.id ? device : d).toList();
    } else {
      state = [...state, device];
    }
  }

  void startCleanup() {
    _cleanupTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      final now = DateTime.now();
      state = state.where((d) {
        return now.difference(d.lastSeen).inSeconds < 15;
      }).toList();
    });
  }

  void remove(String id) {
    state = state.where((d) => d.id != id).toList();
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    super.dispose();
  }
}

// ─── Events ─────────────────────────────────────────────────────────────────

abstract class TransferEvent {}

class TransferStartedEvent extends TransferEvent {
  final TransferModel model;
  TransferStartedEvent(this.model);
}

class TransferProgressEvent extends TransferEvent {
  final String id;
  final int bytesTransferred;
  final int totalBytes;
  TransferProgressEvent(this.id, this.bytesTransferred, this.totalBytes);
}

class TransferCompletedEvent extends TransferEvent {
  final String id;
  final String savedPath;
  TransferCompletedEvent(this.id, this.savedPath);
}

class TransferFailedEvent extends TransferEvent {
  final String id;
  final String error;
  TransferFailedEvent(this.id, this.error);
}
