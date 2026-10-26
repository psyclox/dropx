import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Ultra-modern DropX Brand Logo widget that uses the official brand assets
/// with optional glow, rounded corners, and customizable dimensions.
class DropXLogo extends StatelessWidget {
  final double size;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool showGlow;
  final bool isHero;
  final BoxFit fit;

  const DropXLogo({
    super.key,
    this.size = 48,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.showGlow = false,
    this.isHero = false,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final w = width ?? size;
    final h = height ?? size;

    Widget logoImage = Image.asset(
      'assets/dropx_logo.png',
      width: w,
      height: h,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to spaced filename or stylized fallback if needed
        return Image.asset(
          'assets/dropx logo.png',
          width: w,
          height: h,
          fit: fit,
          errorBuilder: (_, __, ___) => _buildFallback(w, h),
        );
      },
    );

    if (borderRadius > 0) {
      logoImage = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: logoImage,
      );
    }

    if (showGlow) {
      logoImage = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.2),
              blurRadius: 36,
              spreadRadius: 4,
            ),
          ],
        ),
        child: logoImage,
      );
    }

    if (isHero) {
      return Hero(
        tag: 'dropx_app_logo',
        child: logoImage,
      );
    }

    return logoImage;
  }

  Widget _buildFallback(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: AppColors.primaryGradient,
      ),
      child: Center(
        child: Text(
          'X',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

/// DropX Brand Banner widget using the banner asset
class DropXBanner extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const DropXBanner({
    super.key,
    this.width,
    this.height = 120,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    Widget bannerImage = Image.asset(
      'assets/dropx_banner.png',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/dropx banner.png',
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        );
      },
    );

    if (borderRadius > 0) {
      bannerImage = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: bannerImage,
      );
    }

    return bannerImage;
  }
}
