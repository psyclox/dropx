import 'dart:math' as math;

class DeviceModel {
  final String id;
  final String name;
  final String ip;
  final String platform;
  final DateTime lastSeen;
  final bool isConnected;
  final int signalStrength;
  final String? avatarColor;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.ip,
    required this.platform,
    required this.lastSeen,
    this.isConnected = false,
    this.signalStrength = 0,
    this.avatarColor,
  });

  DeviceModel copyWith({
    String? id,
    String? name,
    String? ip,
    String? platform,
    DateTime? lastSeen,
    bool? isConnected,
    int? signalStrength,
    String? avatarColor,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ip: ip ?? this.ip,
      platform: platform ?? this.platform,
      lastSeen: lastSeen ?? this.lastSeen,
      isConnected: isConnected ?? this.isConnected,
      signalStrength: signalStrength ?? this.signalStrength,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ip': ip,
      'platform': platform,
      'lastSeen': lastSeen.toIso8601String(),
      'isConnected': isConnected,
      'signalStrength': signalStrength,
      'avatarColor': avatarColor,
    };
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      ip: json['ip'] as String? ?? '',
      platform: json['platform'] as String? ?? 'unknown',
      lastSeen: json['lastSeen'] != null
          ? DateTime.tryParse(json['lastSeen'] as String) ?? DateTime.now()
          : DateTime.now(),
      isConnected: json['isConnected'] as bool? ?? false,
      signalStrength: json['signalStrength'] as int? ?? 0,
      avatarColor: json['avatarColor'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeviceModel(id: $id, name: $name, ip: $ip, platform: $platform)';
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
    if (words.length >= 2 && words[0].isNotEmpty && words[1].isNotEmpty) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, math.min(2, name.length)).toUpperCase();
  }
}
