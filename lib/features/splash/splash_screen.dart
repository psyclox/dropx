import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/dropx_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _orbitController;
  late AnimationController _glowController;
  late AnimationController _textController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Sequence
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textController.forward();
    });

    // Navigate after animation
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _orbitController.dispose();
    _glowController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          // Animated background gradient mesh
          _buildBackground(),
          
          // Floating particles
          _buildParticles(),
          
          // Center logo + text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogo(),
                const SizedBox(height: 32),
                _buildText(),
                const SizedBox(height: 60),
                _buildTagline(),
              ],
            ),
          ),
          
          // Bottom version
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _textController,
                builder: (_, __) => Opacity(
                  opacity: _textController.value,
                  child: const Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.2),
              radius: 1.2 + _pulseController.value * 0.15,
              colors: [
                AppColors.primary.withOpacity(0.12 + _pulseController.value * 0.04),
                AppColors.secondary.withOpacity(0.06),
                AppColors.bgBase,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (context, _) {
        return CustomPaint(
          painter: _ParticlePainter(_orbitController.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _orbitController, _glowController]),
      builder: (_, __) {
        final glow = _glowController.value;
        final orbit = _orbitController.value;
        
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 140 + glow * 8,
              height: 140 + glow * 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.0),
                    AppColors.primary.withOpacity(0.08 + glow * 0.06),
                    AppColors.secondary.withOpacity(0.12 + glow * 0.06),
                    Colors.transparent,
                  ],
                  stops: const [0.3, 0.6, 0.8, 1.0],
                ),
              ),
            ),
            
            // Orbiting ring
            Transform.rotate(
              angle: orbit * 2 * pi,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 55,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Counter-orbiting ring
            Transform.rotate(
              angle: -orbit * 2 * pi * 1.5,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.12),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 43,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Logo container with official DropX brand asset
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.45 + glow * 0.2),
                    blurRadius: 28 + glow * 8,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.25 + glow * 0.1),
                    blurRadius: 42 + glow * 10,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const DropXLogo(
                size: 86,
                borderRadius: 22,
                fit: BoxFit.contain,
              ),
            ),
          ],
        );
      },
    )
    .animate()
    .scale(
      begin: const Offset(0.3, 0.3),
      end: const Offset(1.0, 1.0),
      duration: 800.ms,
      curve: Curves.elasticOut,
    )
    .fadeIn(duration: 400.ms);
  }

  Widget _buildText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (_, __) {
        return Opacity(
          opacity: _textController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _textController.value)),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
                stops: [0.0, 0.6, 1.0],
              ).createShader(bounds),
              child: const Text(
                'DropX',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (_, __) {
        final delayed = (_textController.value - 0.3).clamp(0.0, 1.0) / 0.7;
        return Opacity(
          opacity: delayed,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - delayed)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 1,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 12),
                const Text(
                  'SHARE WITHOUT LIMITS',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 1,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



// ─── Particle Painter ────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_Particle> _particles = List.generate(30, (i) => _Particle(i));

  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final x = (p.x + progress * p.speedX) % 1.0;
      final y = (p.y + progress * p.speedY) % 1.0;
      final opacity = (sin(progress * 2 * pi + p.phase) * 0.5 + 0.5) * p.maxOpacity;

      final paint = Paint()
        ..color = p.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  late final double x;
  late final double y;
  late final double speedX;
  late final double speedY;
  late final double radius;
  late final double phase;
  late final double maxOpacity;
  late final Color color;

  _Particle(int seed) {
    final rand = Random(seed * 7919);
    x = rand.nextDouble();
    y = rand.nextDouble();
    speedX = (rand.nextDouble() - 0.5) * 0.08;
    speedY = (rand.nextDouble() - 0.5) * 0.08;
    radius = rand.nextDouble() * 2 + 0.5;
    phase = rand.nextDouble() * 2 * pi;
    maxOpacity = rand.nextDouble() * 0.4 + 0.05;
    color = rand.nextBool() ? AppColors.primary : AppColors.secondary;
  }
}
