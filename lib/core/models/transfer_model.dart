enum TransferStatus { pending, inProgress, completed, failed, cancelled, paused }
enum TransferDirection { sending, receiving }

class TransferModel {
  final String id;
  final String fileName;
  final int fileSize;
  final String mimeType;
  final String? checksum;
  final String senderName;
  final String? receiverName;
  final TransferStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final TransferDirection direction;
  final String? filePath;
  final String? errorMessage;
  final double progress;
  final int bytesTransferred;
  final double speed; // MB/s
  final String? thumbnailPath;

  const TransferModel({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    this.checksum,
    required this.senderName,
    this.receiverName,
    required this.status,
    required this.createdAt,
    this.completedAt,
    required this.direction,
    this.filePath,
    this.errorMessage,
    this.progress = 0.0,
    this.bytesTransferred = 0,
    this.speed = 0.0,
    this.thumbnailPath,
  });

  TransferModel copyWith({
    String? id,
    String? fileName,
    int? fileSize,
    String? mimeType,
    String? checksum,
    String? senderName,
    String? receiverName,
    TransferStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    TransferDirection? direction,
    String? filePath,
    String? errorMessage,
    double? progress,
    int? bytesTransferred,
    double? speed,
    String? thumbnailPath,
  }) {
    return TransferModel(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      checksum: checksum ?? this.checksum,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      direction: direction ?? this.direction,
      filePath: filePath ?? this.filePath,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
      bytesTransferred: bytesTransferred ?? this.bytesTransferred,
      speed: speed ?? this.speed,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'checksum': checksum,
      'senderName': senderName,
      'receiverName': receiverName,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'direction': direction.name,
      'filePath': filePath,
      'errorMessage': errorMessage,
      'progress': progress,
      'bytesTransferred': bytesTransferred,
      'speed': speed,
      'thumbnailPath': thumbnailPath,
    };
  }

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      mimeType: json['mimeType'] as String? ?? 'application/octet-stream',
      checksum: json['checksum'] as String?,
      senderName: json['senderName'] as String? ?? 'Unknown',
      receiverName: json['receiverName'] as String?,
      status: TransferStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransferStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
      direction: TransferDirection.values.firstWhere(
        (e) => e.name == json['direction'],
        orElse: () => TransferDirection.receiving,
      ),
      filePath: json['filePath'] as String?,
      errorMessage: json['errorMessage'] as String?,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      bytesTransferred: (json['bytesTransferred'] as num?)?.toInt() ?? 0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      thumbnailPath: json['thumbnailPath'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TransferModel(id: $id, fileName: $fileName, status: $status, progress: $progress)';
}

extension TransferModelX on TransferModel {
  bool get isActive => status == TransferStatus.inProgress || status == TransferStatus.pending;
  bool get isCompleted => status == TransferStatus.completed;
  bool get isFailed => status == TransferStatus.failed;
  bool get isCancelled => status == TransferStatus.cancelled;
  
  String get speedLabel {
    if (speed >= 1) return '${speed.toStringAsFixed(1)} MB/s';
    return '${(speed * 1024).toStringAsFixed(0)} KB/s';
  }
  
  String get sizeLabel {
    if (fileSize >= 1024 * 1024 * 1024) {
      return '${(fileSize / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
    }
    if (fileSize >= 1024 * 1024) {
      return '${(fileSize / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    if (fileSize >= 1024) {
      return '${(fileSize / 1024).toStringAsFixed(0)} KB';
    }
    return '$fileSize B';
  }
  
  Duration? get estimatedTimeRemaining {
    if (speed <= 0 || progress >= 1.0) return null;
    final remainingBytes = fileSize - bytesTransferred;
    final seconds = remainingBytes / (speed * 1024 * 1024);
    return Duration(seconds: seconds.ceil());
  }
  
  String get fileTypeLabel {
    final ext = filePath?.split('.').last.toLowerCase() ?? 
                fileName.split('.').last.toLowerCase();
    return ext.toUpperCase();
  }
}
