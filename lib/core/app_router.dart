import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/send/send_screen.dart';
import '../features/receive/receive_screen.dart';
import '../features/transfer/transfer_screen.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/media_viewer/media_viewer_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/connect/connect_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'send',
            builder: (context, state) => const SendScreen(),
          ),
          GoRoute(
            path: 'receive',
            builder: (context, state) => const ReceiveScreen(),
          ),
          GoRoute(
            path: 'connect',
            builder: (context, state) => const ConnectScreen(),
          ),
          GoRoute(
            path: 'transfer/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TransferScreen(transferId: id);
            },
          ),
          GoRoute(
            path: 'history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'media/:path',
            builder: (context, state) {
              final filePath = state.pathParameters['path']!;
              return MediaViewerScreen(filePath: Uri.decodeComponent(filePath));
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Text(
          'Page not found',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    ),
  );
});
