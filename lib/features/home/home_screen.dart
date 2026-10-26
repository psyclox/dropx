import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/app_providers.dart';
import '../../shared/widgets/glassmorphic_card.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/svg_icon_widget.dart';
import '../../shared/widgets/dropx_logo.dart';
import '../../core/theme/app_icons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _bgController;
  late AnimationController _cardController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          // Animated gradient background
          _buildAnimatedBackground(size),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(profile, context),
                Expanded(
                  child: _buildHomeContent(context, size),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(Size size) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                -0.5 + _bgController.value * 1.0,
                -0.8 + _bgController.value * 0.3,
              ),
              radius: 1.8,
              colors: [
                AppColors.primary.withOpacity(0.06),
                AppColors.secondary.withOpacity(0.03),
                AppColors.bgBase,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(UserProfile profile, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Logo + Name
          Row(
            children: [
              const DropXLogo(
                size: 36,
                borderRadius: 10,
                showGlow: true,
              ),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                child: const Text(
                  'DropX',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          
          // Profile avatar
          GestureDetector(
            onTap: () => context.go('/home/profile'),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  profile.name.isNotEmpty 
                      ? profile.name[0].toUpperCase() 
                      : 'M',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Settings
          GestureDetector(
            onTap: () => context.go('/home/settings'),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgCard,
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: SvgIconWidget(
                  svgPath: AppIcons.settings,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.3, end: 0),
    );
  }

  Widget _buildHomeContent(BuildContext context, Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero section
          _buildHeroSection(context),
          const SizedBox(height: 32),
          
          // Quick Stats
          _buildQuickStats(),
          const SizedBox(height: 28),
          
          // Recent Transfers
          _buildRecentTransfers(context),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Anything,',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -1,
            height: 1.1,
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3, end: 0),
        
        ShaderMask(
          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
          child: const Text(
            'Anywhere.',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 8),
        
        const Text(
          'No internet. No limits. Blazing fast.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
            letterSpacing: 0.2,
          ),
        ).animate().fadeIn(delay: 300.ms),
        
        const SizedBox(height: 28),
        
        // Main action buttons
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                label: 'Send',
                subtitle: 'Share files',
                iconPath: AppIcons.send,
                gradient: AppColors.sendGradient,
                onTap: () => context.go('/home/send'),
                delay: 400,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                label: 'Receive',
                subtitle: 'Accept files',
                iconPath: AppIcons.receive,
                gradient: AppColors.receiveGradient,
                onTap: () => context.go('/home/receive'),
                delay: 500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Connect button
        _ConnectCard(onTap: () => context.go('/home/connect')),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ).animate().fadeIn(delay: 500.ms),
        
        const SizedBox(height: 14),
        
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Sent',
                value: '0',
                unit: 'files',
                iconPath: AppIcons.send,
                color: AppColors.primary,
                delay: 550,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Received',
                value: '0',
                unit: 'files',
                iconPath: AppIcons.receive,
                color: AppColors.accent,
                delay: 600,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Speed',
                value: 'N/A',
                unit: 'avg',
                iconPath: AppIcons.speed,
                color: AppColors.secondary,
                delay: 650,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTransfers(BuildContext context) {
    final history = ref.watch(transferHistoryProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recent Transfers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/home/history'),
              child: const Text(
                'See All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 700.ms),
        
        const SizedBox(height: 8),
        
        if (history.isEmpty)
          _EmptyHistoryPlaceholder()
        else
          ...history.take(5).map((item) => _TransferHistoryItem(item: item)),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              _NavItem(
                icon: AppIcons.home,
                label: 'Home',
                isSelected: _selectedIndex == 0,
                onTap: () {
                  setState(() => _selectedIndex = 0);
                },
              ),
              _NavItem(
                icon: AppIcons.history,
                label: 'History',
                isSelected: _selectedIndex == 1,
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  context.go('/home/history');
                },
              ),
              _NavItem(
                icon: AppIcons.folder,
                label: 'Files',
                isSelected: _selectedIndex == 2,
                onTap: () {
                  setState(() => _selectedIndex = 2);
                  context.go('/home/send');
                },
              ),
              _NavItem(
                icon: AppIcons.settings,
                label: 'Settings',
                isSelected: _selectedIndex == 3,
                onTap: () {
                  setState(() => _selectedIndex = 3);
                  context.go('/home/settings');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Action Card ─────────────────────────────────────────────────────────────

class _ActionCard extends StatefulWidget {
  final String label;
  final String subtitle;
  final String iconPath;
  final Gradient gradient;
  final VoidCallback onTap;
  final int delay;

  const _ActionCard({
    required this.label,
    required this.subtitle,
    required this.iconPath,
    required this.gradient,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
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
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (widget.gradient as LinearGradient)
                    .colors
                    .first
                    .withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: -20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: SvgIconWidget(
                          svgPath: widget.iconPath,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(delay: Duration(milliseconds: widget.delay))
    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), 
           delay: Duration(milliseconds: widget.delay), curve: Curves.easeOutBack);
  }
}

// ─── Connect Card ─────────────────────────────────────────────────────────────

class _ConnectCard extends StatefulWidget {
  final VoidCallback onTap;
  
  const _ConnectCard({required this.onTap});

  @override
  State<_ConnectCard> createState() => _ConnectCardState();
}

class _ConnectCardState extends State<_ConnectCard> {
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
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1A40), Color(0xFF252545)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: SvgIconWidget(
                      svgPath: AppIcons.hotspot,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connect to Device',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Scan QR or browse nearby devices',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                SvgIconWidget(
                  svgPath: AppIcons.chevronRight,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2, end: 0);
  }
}

// ─── Stat Card ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String iconPath;
  final Color color;
  final int delay;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.iconPath,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgIconWidget(svgPath: iconPath, size: 18, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      delay: Duration(milliseconds: delay),
      curve: Curves.easeOutBack,
    );
  }
}

// ─── Transfer History Item ────────────────────────────────────────────────────

class _TransferHistoryItem extends StatelessWidget {
  final Map<String, dynamic> item;
  
  const _TransferHistoryItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgIconWidget(
                svgPath: AppIcons.file,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['fileName'] as String? ?? 'Unknown file',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  item['size'] as String? ?? '',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                color: AppColors.success,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty History ───────────────────────────────────────────────────────────

class _EmptyHistoryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgIconWidget(
                svgPath: AppIcons.history,
                size: 28,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No transfers yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Start sharing files with nearby devices',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).scale(
      begin: const Offset(0.9, 0.9),
      curve: Curves.easeOutBack,
      delay: 800.ms,
    );
  }
}

// ─── Nav Item ────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgIconWidget(
                  svgPath: icon,
                  size: 20,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Small Logo Mark ─────────────────────────────────────────────────────────

class _SmallLogoMark extends StatelessWidget {
  const _SmallLogoMark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(18, 18),
      painter: _SmallLogoPainter(),
    );
  }
}

class _SmallLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    canvas.drawLine(Offset(w * 0.1, h * 0.7), Offset(w * 0.5, h * 0.25), paint);
    canvas.drawLine(Offset(w * 0.5, h * 0.25), Offset(w * 0.9, h * 0.7), paint);
    canvas.drawLine(Offset(w * 0.1, h * 0.3), Offset(w * 0.5, h * 0.75), paint);
    canvas.drawLine(Offset(w * 0.5, h * 0.75), Offset(w * 0.9, h * 0.3), paint);

    final boltPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bolt = Path()
      ..moveTo(w * 0.5, h * 0.15)
      ..lineTo(w * 0.38, h * 0.5)
      ..lineTo(w * 0.48, h * 0.5)
      ..lineTo(w * 0.5, h * 0.85)
      ..lineTo(w * 0.62, h * 0.5)
      ..lineTo(w * 0.52, h * 0.5)
      ..close();
    canvas.drawPath(bolt, boltPaint);
  }

  @override
  bool shouldRepaint(_SmallLogoPainter _) => false;
}
