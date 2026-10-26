import 'package:flutter/material.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;
  final Border? border;
  final Color? color;
  final EdgeInsets? padding;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.border,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: (color ?? Colors.white).withOpacity(opacity),
          borderRadius: borderRadius,
          border: border ?? Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
