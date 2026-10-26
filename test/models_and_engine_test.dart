import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_test/flutter_test.dart';
import 'package:dropx/core/models/device_model.dart';
import 'package:dropx/core/models/transfer_model.dart';

void main() {
  group('DeviceModel Tests', () {
    test('Device serialization and deserialization', () {
      final now = DateTime.now();
      final device = DeviceModel(
        id: 'dev-123',
        name: 'Pixel 8 Pro',
        ip: '192.168.1.50',
        platform: 'android',
        lastSeen: now,
        isConnected: true,
        signalStrength: 85,
        avatarColor: '#4F6EFF',
      );

      final json = device.toJson();
      expect(json['id'], 'dev-123');
      expect(json['name'], 'Pixel 8 Pro');
      expect(json['platform'], 'android');

      final restored = DeviceModel.fromJson(json);
      expect(restored.id, device.id);
      expect(restored.name, device.name);
      expect(restored.ip, device.ip);
      expect(restored.platform, device.platform);
      expect(restored.isConnected, true);
      expect(restored.signalStrength, 85);
      expect(restored.isAndroid, true);
      expect(restored.isWindows, false);
      expect(restored.platformLabel, 'Android');
      expect(restored.initials, 'P8');
    });

    test('Device copyWith test', () {
      final device = DeviceModel(
        id: 'dev-1',
        name: 'My Laptop',
        ip: '192.168.1.100',
        platform: 'windows',
        lastSeen: DateTime.now(),
      );

      final updated = device.copyWith(name: 'Work PC', isConnected: true);
      expect(updated.id, 'dev-1');
      expect(updated.name, 'Work PC');
      expect(updated.isConnected, true);
      expect(updated.isWindows, true);
    });
  });

  group('TransferModel Tests', () {
    test('Transfer serialization, formatting, and speeds', () {
      final now = DateTime.now();
      final transfer = TransferModel(
        id: 'tx-001',
        fileName: '4k_video.mp4',
        fileSize: 1024 * 1024 * 500, // 500 MB
        mimeType: 'video/mp4',
        senderName: 'DropX Desktop',
        receiverName: 'Pixel 8',
        status: TransferStatus.inProgress,
        createdAt: now,
        direction: TransferDirection.sending,
        progress: 0.5,
        bytesTransferred: 1024 * 1024 * 250,
        speed: 45.5,
      );

      expect(transfer.sizeLabel, '500.0 MB');
      expect(transfer.speedLabel, '45.5 MB/s');
      expect(transfer.fileTypeLabel, 'MP4');
      expect(transfer.isActive, true);
      expect(transfer.isCompleted, false);

      final json = transfer.toJson();
      expect(json['id'], 'tx-001');
      expect(json['status'], 'inProgress');
      expect(json['direction'], 'sending');

      final fromJson = TransferModel.fromJson(json);
      expect(fromJson.id, transfer.id);
      expect(fromJson.fileName, transfer.fileName);
      expect(fromJson.fileSize, transfer.fileSize);
      expect(fromJson.status, TransferStatus.inProgress);
      expect(fromJson.direction, TransferDirection.sending);
    });

    test('Transfer estimated remaining time calculation', () {
      final transfer = TransferModel(
        id: 'tx-002',
        fileName: 'dataset.zip',
        fileSize: 100 * 1024 * 1024, // 100 MB
        mimeType: 'application/zip',
        senderName: 'PC',
        status: TransferStatus.inProgress,
        createdAt: DateTime.now(),
        direction: TransferDirection.sending,
        progress: 0.5,
        bytesTransferred: 50 * 1024 * 1024, // 50 MB remaining
        speed: 25.0, // 25 MB/s -> should take ~2 seconds
      );

      final eta = transfer.estimatedTimeRemaining;
      expect(eta, isNotNull);
      expect(eta!.inSeconds, 2);
    });

    test('Unlimited size chunked stream SHA-256 verification', () async {
      // Simulate chunked streaming data
      final chunks = [
        utf8.encode('DropX ultra-fast offline chunk 1: '),
        utf8.encode('unlimited file size streaming support '),
        utf8.encode('for TB-sized media transfers.'),
      ];

      final stream = Stream.fromIterable(chunks);
      final digest = await crypto.sha256.bind(stream).first;

      final combined = chunks.expand((x) => x).toList();
      final expectedDigest = crypto.sha256.convert(combined);

      expect(digest.toString(), expectedDigest.toString());
    });
  });
}
