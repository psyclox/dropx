import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../shared/widgets/svg_icon_widget.dart';
import '../../shared/widgets/dropx_logo.dart';
import '../../core/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSection(
                      title: 'Transfers',
                      children: [
                        _SettingsTile(
                          icon: AppIcons.check,
                          iconColor: AppColors.success,
                          title: 'Auto Accept',
                          subtitle: 'Automatically accept incoming transfers',
                          trailing: Switch(
                            value: settings.autoAccept,
                            onChanged: (_) => ref.read(appSettingsProvider.notifier).toggle('autoAccept'),
                          ),
                        ),
                        _SettingsTile(
                          icon: AppIcons.speed,
                          iconColor: AppColors.primary,
                          title: 'Show Transfer Speed',
                          subtitle: 'Display real-time transfer speed',
                          trailing: Switch(
                            value: settings.showTransferSpeed,
                            onChanged: (_) => ref.read(appSettingsProvider.notifier).toggle('showSpeed'),
                          ),
                        ),
                        _SettingsTile(
                          icon: AppIcons.wifi,
                          iconColor: AppColors.info,
                          title: 'WiFi Hotspot Mode',
                          subtitle: 'Only transfer over WiFi hotspot',
                          trailing: Switch(
                            value: settings.wifiOnlyMode,
                            onChanged: (_) => ref.read(appSettingsProvider.notifier).toggle('wifiOnly'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      title: 'Storage',
                      children: [
                        _SettingsTile(
                          icon: AppIcons.folder,
                          iconColor: AppColors.fileDocument,
                          title: 'Save Location',
                          subtitle: settings.receiveSavePath.isEmpty
                              ? 'DropX folder (default)'
                              : settings.receiveSavePath,
                          onTap: () => _pickSavePath(context, ref),
                          trailing: SvgIconWidget(
                            svgPath: AppIcons.chevronRight,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ),
                        _SettingsTile(
                          icon: AppIcons.storage,
                          iconColor: AppColors.secondary,
                          title: 'Storage Usage',
                          subtitle: 'View and manage DropX files',
                          onTap: () {},
                          trailing: SvgIconWidget(
                            svgPath: AppIcons.chevronRight,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      title: 'Notifications & Sound',
                      children: [
                        _SettingsTile(
                          icon: AppIcons.notification,
                          iconColor: AppColors.warning,
                          title: 'Notifications',
                          subtitle: 'Show transfer notifications',
                          trailing: Switch(
                            value: settings.showNotifications,
                            onChanged: (_) => ref.read(appSettingsProvider.notifier).toggle('notifications'),
                          ),
                        ),
                        _SettingsTile(
                          icon: AppIcons.audio,
                          iconColor: AppColors.accent,
                          title: 'Sound Effects',
                          subtitle: 'Play sounds on transfer events',
                          trailing: Switch(
                            value: settings.soundEnabled,
                            onChanged: (_) => ref.read(appSettingsProvider.notifier).toggle('sound'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      title: 'Display',
                      children: [
                        _SettingsTile(
                          icon: AppIcons.theme,
                          iconColor: AppColors.primary,
                          title: 'Keep Screen On',
                          subtitle: 'Prevent screen sleep during transfers',
                          trailing: Switch(
                            value: settings.keepScreenOn,
                            onChanged: (_) => ref.read(appSettingsProvider.notifier).toggle('keepScreen'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      title: 'About',
                      children: [
                        _SettingsTile(
                          icon: AppIcons.info,
                          iconColor: AppColors.primary,
                          title: 'DropX',
                          subtitle: 'Version 1.0.0 • Tap for details',
                          onTap: () => _showAboutDialog(context),
                          trailing: SvgIconWidget(
                            svgPath: AppIcons.chevronRight,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ),
                        _SettingsTile(
                          icon: AppIcons.security,
                          iconColor: AppColors.success,
                          title: 'Privacy & Security',
                          subtitle: 'No data collected, fully offline P2P transfer',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/home'),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: SvgIconWidget(svgPath: AppIcons.back, size: 18, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final isLast = entry.key == children.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    const Divider(
                      height: 1,
                      indent: 56,
                      endIndent: 16,
                      color: AppColors.border,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Future<void> _pickSavePath(BuildContext context, WidgetRef ref) async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      ref.read(appSettingsProvider.notifier).update(
        ref.read(appSettingsProvider).copyWith(receiveSavePath: path),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const DropXBanner(
              height: 120,
              borderRadius: 16,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const DropXLogo(
                  size: 56,
                  borderRadius: 16,
                  showGlow: true,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DropX',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ultra-fast Offline P2P Sharing',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'v1.0.0 • Android & Windows Client',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  _FeatureBullet(
                    title: '100% Offline',
                    subtitle: 'Direct peer-to-peer Wi-Fi hotspot & local discovery with no internet needed.',
                  ),
                  SizedBox(height: 10),
                  _FeatureBullet(
                    title: 'Unlimited Size & Any File',
                    subtitle: 'Full streaming engine for GBs and TBs limited only by device storage.',
                  ),
                  SizedBox(height: 10),
                  _FeatureBullet(
                    title: 'Zero Ads & Zero Purchases',
                    subtitle: 'Pure clean utility built for speed and complete privacy.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FeatureBullet({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatefulWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null ? (_) {
        setState(() => _pressed = false);
        widget.onTap!();
      } : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _pressed ? AppColors.bgCardHover : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgIconWidget(svgPath: widget.icon, size: 18, color: widget.iconColor),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (widget.trailing != null) ...[
              const SizedBox(width: 8),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
