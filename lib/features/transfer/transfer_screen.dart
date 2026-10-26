import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../shared/widgets/svg_icon_widget.dart';
import '../../shared/widgets/dropx_logo.dart';
import '../../core/models/transfer_model.dart';
import '../../core/services/transfer_service.dart';

class TransferScreen extends ConsumerStatefulWidget {
  final String transferId;
  
  const TransferScreen({super.key, required this.transferId});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _particleController;
  late AnimationController _checkController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _particleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transfers = ref.watch(activeTransfersProvider);
    final transfer = transfers.where((t) => t.id == widget.transferId).firstOrNull;
    
    if (transfer == null) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Transfer not found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          _buildBackground(transfer),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, transfer),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildTransferVisual(transfer),
                        const SizedBox(height: 32),
                        _buildProgressCard(transfer),
                        const SizedBox(height: 16),
                        _buildTransferDetails(transfer),
                        const SizedBox(height: 24),
                        if (transfer.isCompleted) _buildCompletedActions(context, transfer),
                        if (transfer.isFailed) _buildFailedActions(context),
                        if (transfer.isActive) _buildActiveActions(transfer),
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

  Widget _buildBackground(TransferModel transfer) {
    final color = transfer.isCompleted
        ? AppColors.success
        : transfer.isFailed
            ? AppColors.error
            : AppColors.primary;
    
    return AnimatedBuilder(
      animation: _particleController,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.5),
              radius: 1.5,
              colors: [
                color.withOpacity(0.08),
                AppColors.bgBase,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, TransferModel transfer) {
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
          Expanded(
            child: Row(
              children: [
                const DropXLogo(size: 26, borderRadius: 7),
                const SizedBox(width: 8),
                Text(
                  transfer.direction == TransferDirection.sending
                      ? 'Sending Files'
                      : 'Receiving Files',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          if (transfer.isActive)
            SvgIconWidget(
              svgPath: AppIcons.more,
              size: 22,
              color: AppColors.textMuted,
            ),
        ],
      ),
    );
  }

  Widget _buildTransferVisual(TransferModel transfer) {
    final isSending = transfer.direction == TransferDirection.sending;
    final color = transfer.isCompleted
        ? AppColors.success
        : transfer.isFailed
            ? AppColors.error
            : isSending
                ? AppColors.primary
                : AppColors.accent;
    
    return Column(
      children: [
        // Animated transfer visualization
        SizedBox(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Source device
              Positioned(
                left: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSending ? color.withOpacity(0.5) : AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: SvgIconWidget(
                          svgPath: AppIcons.phone,
                          size: 32,
                          color: isSending ? color : AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isSending ? 'You' : transfer.senderName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Animated transfer arrow
              _buildTransferArrow(transfer, color),
              
              // Target device
              Positioned(
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: !isSending ? color.withOpacity(0.5) : AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: SvgIconWidget(
                          svgPath: AppIcons.laptop,
                          size: 32,
                          color: !isSending ? color : AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isSending ? (transfer.receiverName ?? 'Target') : 'You',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Status icon
        if (transfer.isCompleted)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withOpacity(0.1),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Center(
              child: SvgIconWidget(svgPath: AppIcons.checkCircle, size: 28, color: AppColors.success),
            ),
          ).animate().scale(curve: Curves.elasticOut, duration: 600.ms)
        else if (transfer.isFailed)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error.withOpacity(0.1),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Center(
              child: SvgIconWidget(svgPath: AppIcons.close, size: 28, color: AppColors.error),
            ),
          ).animate().shake(),
      ],
    );
  }

  Widget _buildTransferArrow(TransferModel transfer, Color color) {
    return SizedBox(
      width: 120,
      height: 50,
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (_, __) {
          return CustomPaint(
            painter: _TransferArrowPainter(
              progress: _particleController.value,
              isActive: transfer.isActive,
              color: color,
              isSending: transfer.direction == TransferDirection.sending,
              isCompleted: transfer.isCompleted,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(TransferModel transfer) {
    final color = transfer.isCompleted
        ? AppColors.success
        : transfer.isFailed
            ? AppColors.error
            : AppColors.primary;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transfer.fileName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transfer.sizeLabel,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Progress percentage
              Text(
                '${(transfer.progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: transfer.progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 14),
          
          // Speed + ETA
          Row(
            children: [
              if (transfer.isActive) ...[
                SvgIconWidget(svgPath: AppIcons.speed, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  transfer.speedLabel,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                SvgIconWidget(svgPath: AppIcons.history, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  transfer.estimatedTimeRemaining != null
                      ? _formatDuration(transfer.estimatedTimeRemaining!)
                      : '--:--',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ] else if (transfer.isCompleted) ...[
                SvgIconWidget(svgPath: AppIcons.checkCircle, size: 14, color: AppColors.success),
                const SizedBox(width: 4),
                const Text(
                  'Transfer Complete',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else if (transfer.isFailed) ...[
                SvgIconWidget(svgPath: AppIcons.warning, size: 14, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  transfer.errorMessage ?? 'Transfer failed',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransferDetails(TransferModel transfer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'File Type',
            value: transfer.fileTypeLabel,
            iconPath: AppIcons.file,
          ),
          const SizedBox(height: 12),
          _DetailRow(
            label: 'Direction',
            value: transfer.direction == TransferDirection.sending ? 'Sending' : 'Receiving',
            iconPath: transfer.direction == TransferDirection.sending
                ? AppIcons.send : AppIcons.receive,
          ),
          const SizedBox(height: 12),
          _DetailRow(
            label: 'From',
            value: transfer.senderName,
            iconPath: AppIcons.profile,
          ),
          if (transfer.isCompleted && transfer.filePath != null) ...[
            const SizedBox(height: 12),
            _DetailRow(
              label: 'Saved To',
              value: transfer.filePath!.length > 40
                  ? '...${transfer.filePath!.substring(transfer.filePath!.length - 37)}'
                  : transfer.filePath!,
              iconPath: AppIcons.folder,
            ),
          ],
          if (transfer.checksum != null) ...[
            const SizedBox(height: 12),
            _DetailRow(
              label: 'Checksum',
              value: transfer.isCompleted ? 'Verified' : 'Pending',
              iconPath: AppIcons.security,
              valueColor: transfer.isCompleted ? AppColors.success : AppColors.textMuted,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletedActions(BuildContext context, TransferModel transfer) {
    return Column(
      children: [
        if (transfer.filePath != null) ...[
          _ActionButton(
            label: 'Open File',
            iconPath: AppIcons.open,
            gradient: AppColors.primaryGradient,
            onTap: () {
              // Open file with OpenFileX
            },
          ),
          const SizedBox(height: 10),
        ],
        _ActionButton(
          label: 'Share Again',
          iconPath: AppIcons.share,
          color: AppColors.bgCard,
          borderColor: AppColors.border,
          textColor: AppColors.textPrimary,
          onTap: () => context.go('/home/send'),
        ),
        const SizedBox(height: 10),
        _ActionButton(
          label: 'Back to Home',
          iconPath: AppIcons.home,
          color: Colors.transparent,
          textColor: AppColors.textMuted,
          onTap: () => context.go('/home'),
        ),
      ],
    );
  }

  Widget _buildFailedActions(BuildContext context) {
    return Column(
      children: [
        _ActionButton(
          label: 'Retry',
          iconPath: AppIcons.refresh,
          gradient: AppColors.primaryGradient,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        _ActionButton(
          label: 'Back to Home',
          iconPath: AppIcons.home,
          color: Colors.transparent,
          textColor: AppColors.textMuted,
          onTap: () => context.go('/home'),
        ),
      ],
    );
  }

  Widget _buildActiveActions(TransferModel transfer) {
    return _ActionButton(
      label: 'Cancel Transfer',
      iconPath: AppIcons.close,
      color: AppColors.bgCard,
      borderColor: AppColors.error.withOpacity(0.3),
      textColor: AppColors.error,
      onTap: () {
        ref.read(activeTransfersProvider.notifier).cancel(transfer.id);
        context.go('/home');
      },
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds % 60}s';
    return '${d.inSeconds}s';
  }
}

// ─── Transfer Arrow Painter ───────────────────────────────────────────────────

class _TransferArrowPainter extends CustomPainter {
  final double progress;
  final bool isActive;
  final Color color;
  final bool isSending;
  final bool isCompleted;

  _TransferArrowPainter({
    required this.progress,
    required this.isActive,
    required this.color,
    required this.isSending,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    // Draw dashed line
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(min(startX + dashWidth, size.width), size.height / 2),
        linePaint,
      );
      startX += dashWidth + dashSpace;
    }
    
    if (!isActive && !isCompleted) return;
    
    // Animated particles
    for (int i = 0; i < 3; i++) {
      final offset = (progress + i * 0.33) % 1.0;
      final x = isSending ? offset * size.width : (1 - offset) * size.width;
      final particlePaint = Paint()
        ..color = color.withOpacity(1.0 - offset * 0.5)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, size.height / 2), 4 * (1 - offset * 0.5), particlePaint);
    }
    
    // Arrow head
    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    final arrowX = isSending ? size.width - 8.0 : 8.0;
    final arrowPath = Path();
    if (isSending) {
      arrowPath.moveTo(arrowX - 8.0, size.height / 2 - 6.0);
      arrowPath.lineTo(arrowX, size.height / 2);
      arrowPath.lineTo(arrowX - 8.0, size.height / 2 + 6.0);
    } else {
      arrowPath.moveTo(arrowX + 8.0, size.height / 2 - 6.0);
      arrowPath.lineTo(arrowX, size.height / 2);
      arrowPath.lineTo(arrowX + 8.0, size.height / 2 + 6.0);
    }
    canvas.drawPath(arrowPath, arrowPaint);
  }

  double min(double a, double b) => a < b ? a : b;

  @override
  bool shouldRepaint(_TransferArrowPainter old) => old.progress != progress;
}

// ─── Detail Row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.iconPath,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgIconWidget(svgPath: iconPath, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _ActionButton extends StatefulWidget {
  final String label;
  final String iconPath;
  final Gradient? gradient;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.iconPath,
    required this.onTap,
    this.gradient,
    this.color,
    this.borderColor,
    this.textColor,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            color: widget.gradient == null ? (widget.color ?? AppColors.bgCard) : null,
            borderRadius: BorderRadius.circular(16),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!)
                : null,
            boxShadow: widget.gradient != null
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgIconWidget(
                svgPath: widget.iconPath,
                size: 18,
                color: widget.textColor ?? Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.textColor ?? Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
