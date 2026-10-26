import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../shared/widgets/svg_icon_widget.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/transfer_service.dart';

class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key});

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen>
    with TickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _pulseController;
  late AnimationController _radarController;
  String? _myIp;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    
    _loadNetworkInfo();
  }

  Future<void> _loadNetworkInfo() async {
    // Load IP
    setState(() {
      _myIp = '192.168.x.x'; // Will be populated from NetworkInfo
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          // Animated radar background
          _buildRadarBackground(),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildStatusCard(profile),
                        const SizedBox(height: 24),
                        _buildQrSection(profile),
                        const SizedBox(height: 24),
                        _buildInfoCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarBackground() {
    return AnimatedBuilder(
      animation: _radarController,
      builder: (_, __) {
        return CustomPaint(
          painter: _RadarPainter(_radarController.value, _isListening),
          size: MediaQuery.of(context).size,
        );
      },
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
                child: SvgIconWidget(
                  svgPath: AppIcons.back,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receive Files',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Ready to receive from nearby devices',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(UserProfile profile) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isListening
                  ? AppColors.accent.withOpacity(0.4 + _pulseController.value * 0.2)
                  : AppColors.border,
            ),
            boxShadow: _isListening
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.1 + _pulseController.value * 0.05),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              // Avatar with pulsing ring
              Stack(
                alignment: Alignment.center,
                children: [
                  if (_isListening)
                    Container(
                      width: 100 + _pulseController.value * 12,
                      height: 100 + _pulseController.value * 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent.withOpacity(
                            (1 - _pulseController.value) * 0.5,
                          ),
                          width: 2,
                        ),
                      ),
                    ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _isListening
                          ? AppColors.receiveGradient
                          : const LinearGradient(
                              colors: [AppColors.bgCardHover, AppColors.bgCard],
                            ),
                      border: Border.all(
                        color: _isListening ? AppColors.accent : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'M',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                _isListening ? 'Ready to receive files' : 'Tap to start receiving',
                style: TextStyle(
                  fontSize: 13,
                  color: _isListening ? AppColors.accent : AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Toggle button
              GestureDetector(
                onTap: _toggleListening,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: _isListening
                        ? AppColors.receiveGradient
                        : null,
                    color: _isListening ? null : AppColors.bgBase,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isListening ? Colors.transparent : AppColors.border,
                    ),
                    boxShadow: _isListening
                        ? [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgIconWidget(
                        svgPath: _isListening ? AppIcons.pause : AppIcons.receive,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isListening ? 'Stop Receiving' : 'Start Receiving',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).animate().fadeIn(duration: 400.ms).scale(
      begin: const Offset(0.9, 0.9),
      curve: Curves.easeOutBack,
    );
  }

  Widget _buildQrSection(UserProfile profile) {
    final qrData = 'dropx://${_myIp ?? '0.0.0.0'}:49152?name=${Uri.encodeComponent(profile.name)}&id=${profile.deviceId}';
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Scan to Connect',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Spacer(),
              SvgIconWidget2(AppIcons.qrCode, 20, AppColors.textMuted),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 180,
              backgroundColor: Colors.white,
              embeddedImage: const AssetImage('assets/dropx_logo.png'),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(36, 36),
              ),
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: Color(0xFF0A0A0F),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: Color(0xFF0A0A0F),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Device: ${profile.name}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          if (_myIp != null) ...[
            const SizedBox(height: 4),
            SelectableText(
              'IP: $_myIp',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgIconWidget(svgPath: AppIcons.info, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'How to receive',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...[
            '1. Tap "Start Receiving" to begin',
            '2. Ask the sender to open DropX and scan your QR code',
            '3. Or connect to the same hotspot and browse nearby devices',
            '4. Accept the incoming transfer request',
            '5. Files will be saved to your DropX folder',
          ].map((step) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }

  void _toggleListening() {
    setState(() => _isListening = !_isListening);
    
    if (_isListening) {
      // Start transfer server
      ref.read(transferServiceProvider).startServer(
        onTransferStarted: (model) {
          ref.read(activeTransfersProvider.notifier).add(model);
          // Show incoming transfer dialog
          _showIncomingTransferDialog(model.fileName, model.senderName, model.fileSize);
        },
        onProgress: (id, received, total) {
          ref.read(activeTransfersProvider.notifier).updateProgress(id, received, total);
        },
        onComplete: (id, path) {
          ref.read(activeTransfersProvider.notifier).complete(id, path);
        },
        onError: (id, error) {
          ref.read(activeTransfersProvider.notifier).fail(id, error);
        },
      );
    } else {
      ref.read(transferServiceProvider).stopServer();
    }
  }

  void _showIncomingTransferDialog(String fileName, String senderName, int fileSize) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgModal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _IncomingTransferSheet(
        fileName: fileName,
        senderName: senderName,
        fileSize: fileSize,
      ),
    );
  }
}

// ─── Incoming Transfer Sheet ──────────────────────────────────────────────────

class _IncomingTransferSheet extends StatelessWidget {
  final String fileName;
  final String senderName;
  final int fileSize;

  const _IncomingTransferSheet({
    required this.fileName,
    required this.senderName,
    required this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 20),
          
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.receiveGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgIconWidget(
                svgPath: AppIcons.receive,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Text(
            'Incoming Transfer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$senderName wants to send you a file',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgIconWidget(svgPath: AppIcons.file, size: 22, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatSize(fileSize),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text(
                        'Decline',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: AppColors.receiveGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '$bytes B';
  }
}

// ─── Radar Painter ────────────────────────────────────────────────────────────

class _RadarPainter extends CustomPainter {
  final double progress;
  final bool isActive;

  _RadarPainter(this.progress, this.isActive);

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;
    
    final center = Offset(size.width / 2, size.height * 0.35);
    final maxRadius = size.width * 0.7;
    
    for (int i = 0; i < 3; i++) {
      final wave = (progress + i * 0.33) % 1.0;
      final radius = wave * maxRadius;
      final opacity = (1 - wave) * 0.15;
      
      final paint = Paint()
        ..color = AppColors.accent.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) => 
      old.progress != progress || old.isActive != isActive;
}

// ─── Simple SVG icon (inline) ─────────────────────────────────────────────────

class SvgIconWidget2 extends StatelessWidget {
  final String svgPath;
  final double size;
  final Color color;

  const SvgIconWidget2(this.svgPath, this.size, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return SvgIconWidget(svgPath: svgPath, size: size, color: color);
  }
}
