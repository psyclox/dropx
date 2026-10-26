import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

enum TransferStatus { pending, inProgress, completed, failed, cancelled, paused }
enum TransferDirection { sending, receiving }

@freezed
class TransferModel with _$TransferModel {
  const factory TransferModel({
    required String id,
    required String fileName,
    required int fileSize,
    required String mimeType,
    String? checksum,
    required String senderName,
    String? receiverName,
    required TransferStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
    required TransferDirection direction,
    String? filePath,
    String? errorMessage,
    @Default(0.0) double progress,
    @Default(0) int bytesTransferred,
    @Default(0.0) double speed, // MB/s
    String? thumbnailPath,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
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
