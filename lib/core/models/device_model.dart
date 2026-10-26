import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_model.freezed.dart';
part 'device_model.g.dart';

@freezed
class DeviceModel with _$DeviceModel {
  const factory DeviceModel({
    required String id,
    required String name,
    required String ip,
    required String platform,
    required DateTime lastSeen,
    @Default(false) bool isConnected,
    @Default(0) int signalStrength,
    String? avatarColor,
  }) = _DeviceModel;

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);
}

extension DeviceModelX on DeviceModel {
  bool get isAndroid => platform.toLowerCase() == 'android';
  bool get isWindows => platform.toLowerCase() == 'windows';
  bool get isIOS => platform.toLowerCase() == 'ios';
  bool get isMacOS => platform.toLowerCase() == 'macos';
  bool get isLinux => platform.toLowerCase() == 'linux';
  
  String get platformLabel {
    switch (platform.toLowerCase()) {
      case 'android': return 'Android';
      case 'windows': return 'Windows';
      case 'ios': return 'iPhone';
      case 'macos': return 'Mac';
      case 'linux': return 'Linux';
      default: return 'Unknown';
    }
  }
  
  String get initials {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }
}

int min(int a, int b) => a < b ? a : b;
