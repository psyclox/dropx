import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import '../app_router.dart';

// ─── App State ──────────────────────────────────────────────────────────────

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

// ─── Device Profile ─────────────────────────────────────────────────────────

final deviceNameProvider = StateProvider<String>((ref) {
  return 'My Device';
});

final deviceIdProvider = Provider<String>((ref) {
  return const Uuid().v4();
});

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

class UserProfile {
  final String name;
  final String deviceId;
  final String avatarColor;
  final String savePath;
  
  const UserProfile({
    required this.name,
    required this.deviceId,
    required this.avatarColor,
    required this.savePath,
  });
  
  UserProfile copyWith({
    String? name,
    String? deviceId,
    String? avatarColor,
    String? savePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      avatarColor: avatarColor ?? this.avatarColor,
      savePath: savePath ?? this.savePath,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile(
    name: 'My Device',
    deviceId: const Uuid().v4(),
    avatarColor: '#4F6EFF',
    savePath: '',
  )) {
    _load();
  }
  
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      name: prefs.getString('profile_name') ?? 'My Device',
      deviceId: prefs.getString('device_id') ?? const Uuid().v4(),
      avatarColor: prefs.getString('avatar_color') ?? '#4F6EFF',
      savePath: prefs.getString('save_path') ?? '',
    );
  }
  
  Future<void> updateName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    state = state.copyWith(name: name);
  }
  
  Future<void> updateAvatarColor(String color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_color', color);
    state = state.copyWith(avatarColor: color);
  }
  
  Future<void> updateSavePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('save_path', path);
    state = state.copyWith(savePath: path);
  }
}

// ─── App Settings ────────────────────────────────────────────────────────────

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});

class AppSettings {
  final bool autoAccept;
  final bool showNotifications;
  final bool soundEnabled;
  final bool keepScreenOn;
  final bool wifiOnlyMode;
  final String receiveSavePath;
  final bool showTransferSpeed;
  
  const AppSettings({
    this.autoAccept = false,
    this.showNotifications = true,
    this.soundEnabled = true,
    this.keepScreenOn = true,
    this.wifiOnlyMode = false,
    this.receiveSavePath = '',
    this.showTransferSpeed = true,
  });
  
  AppSettings copyWith({
    bool? autoAccept,
    bool? showNotifications,
    bool? soundEnabled,
    bool? keepScreenOn,
    bool? wifiOnlyMode,
    String? receiveSavePath,
    bool? showTransferSpeed,
  }) {
    return AppSettings(
      autoAccept: autoAccept ?? this.autoAccept,
      showNotifications: showNotifications ?? this.showNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      wifiOnlyMode: wifiOnlyMode ?? this.wifiOnlyMode,
      receiveSavePath: receiveSavePath ?? this.receiveSavePath,
      showTransferSpeed: showTransferSpeed ?? this.showTransferSpeed,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings()) {
    _load();
  }
  
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      autoAccept: prefs.getBool('auto_accept') ?? false,
      showNotifications: prefs.getBool('show_notifications') ?? true,
      soundEnabled: prefs.getBool('sound_enabled') ?? true,
      keepScreenOn: prefs.getBool('keep_screen_on') ?? true,
      wifiOnlyMode: prefs.getBool('wifi_only') ?? false,
      receiveSavePath: prefs.getString('receive_path') ?? '',
      showTransferSpeed: prefs.getBool('show_speed') ?? true,
    );
  }
  
  Future<void> update(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_accept', settings.autoAccept);
    await prefs.setBool('show_notifications', settings.showNotifications);
    await prefs.setBool('sound_enabled', settings.soundEnabled);
    await prefs.setBool('keep_screen_on', settings.keepScreenOn);
    await prefs.setBool('wifi_only', settings.wifiOnlyMode);
    await prefs.setString('receive_path', settings.receiveSavePath);
    await prefs.setBool('show_speed', settings.showTransferSpeed);
    state = settings;
  }
  
  void toggle(String key) async {
    switch (key) {
      case 'autoAccept': await update(state.copyWith(autoAccept: !state.autoAccept));
      case 'notifications': await update(state.copyWith(showNotifications: !state.showNotifications));
      case 'sound': await update(state.copyWith(soundEnabled: !state.soundEnabled));
      case 'keepScreen': await update(state.copyWith(keepScreenOn: !state.keepScreenOn));
      case 'wifiOnly': await update(state.copyWith(wifiOnlyMode: !state.wifiOnlyMode));
      case 'showSpeed': await update(state.copyWith(showTransferSpeed: !state.showTransferSpeed));
    }
  }
}

// ─── Transfer History ────────────────────────────────────────────────────────

final transferHistoryProvider = StateNotifierProvider<TransferHistoryNotifier, List<Map<String, dynamic>>>((ref) {
  return TransferHistoryNotifier();
});

class TransferHistoryNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TransferHistoryNotifier() : super([]) {
    _load();
  }
  
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('transfer_history') ?? [];
    // Parse history from JSON strings
    state = [];
  }
  
  Future<void> addEntry(Map<String, dynamic> entry) async {
    final newHistory = [entry, ...state];
    // Keep only last 500 entries
    final trimmed = newHistory.take(500).toList();
    state = trimmed;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('transfer_history', []);
  }
  
  Future<void> clearAll() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('transfer_history');
  }
  
  Future<void> removeEntry(String id) async {
    state = state.where((e) => e['id'] != id).toList();
  }
}

// ─── Connection State ────────────────────────────────────────────────────────

enum ConnectionMode { hotspot, client, direct, none }

final connectionStateProvider = StateNotifierProvider<ConnectionStateNotifier, ConnectionState>((ref) {
  return ConnectionStateNotifier();
});

class ConnectionState {
  final ConnectionMode mode;
  final String? connectedDeviceIp;
  final String? hotspotSsid;
  final bool isReceiving;
  
  const ConnectionState({
    this.mode = ConnectionMode.none,
    this.connectedDeviceIp,
    this.hotspotSsid,
    this.isReceiving = false,
  });
  
  ConnectionState copyWith({
    ConnectionMode? mode,
    String? connectedDeviceIp,
    String? hotspotSsid,
    bool? isReceiving,
  }) {
    return ConnectionState(
      mode: mode ?? this.mode,
      connectedDeviceIp: connectedDeviceIp ?? this.connectedDeviceIp,
      hotspotSsid: hotspotSsid ?? this.hotspotSsid,
      isReceiving: isReceiving ?? this.isReceiving,
    );
  }
}

class ConnectionStateNotifier extends StateNotifier<ConnectionState> {
  ConnectionStateNotifier() : super(const ConnectionState());
  
  void setHotspotMode(String ssid) {
    state = state.copyWith(mode: ConnectionMode.hotspot, hotspotSsid: ssid);
  }
  
  void setClientMode(String deviceIp) {
    state = state.copyWith(mode: ConnectionMode.client, connectedDeviceIp: deviceIp);
  }
  
  void setReceiving(bool receiving) {
    state = state.copyWith(isReceiving: receiving);
  }
  
  void disconnect() {
    state = const ConnectionState();
  }
}
