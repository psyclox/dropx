import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A reusable SVG icon widget that renders SVG strings using CustomPaint.
/// In a real app, use flutter_svg package for full SVG support.
/// This widget provides a consistent icon API.
class SvgIconWidget extends StatelessWidget {
  final String svgPath;
  final double size;
  final Color? color;

  const SvgIconWidget({
    super.key,
    required this.svgPath,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.onSurface;
    
    // Extract the type of icon from the SVG path for custom painting
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _IconPainter(svgPath: svgPath, color: iconColor, size: size),
        size: Size(size, size),
      ),
    );
  }
}

class _IconPainter extends CustomPainter {
  final String svgPath;
  final Color color;
  final double size;

  _IconPainter({required this.svgPath, required this.color, required this.size});

  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0 * (s.width / 24.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final scale = s.width / 24.0;
    canvas.scale(scale, scale);

    // Render based on SVG content pattern matching
    if (svgPath.contains('M22 2L11 13')) {
      _drawSend(canvas, paint);
    } else if (svgPath.contains('M12 2V16M12 16L8 12')) {
      _drawReceive(canvas, paint);
    } else if (svgPath.contains('M5 12H19M19 12L13 6')) {
      _drawArrow(canvas, paint);
    } else if (svgPath.contains('M3 9.5L12 3L21')) {
      _drawHome(canvas, paint);
    } else if (svgPath.contains('M12 8V12L15 15')) {
      _drawHistory(canvas, paint);
    } else if (svgPath.contains('M12 15C13.6569')) {
      _drawSettings(canvas, paint);
    } else if (svgPath.contains('M20 21V19C20')) {
      _drawProfile(canvas, paint);
    } else if (svgPath.contains('M14 2H6')) {
      _drawFile(canvas, paint);
    } else if (svgPath.contains('rect x="3" y="3" width="18"')) {
      _drawImage(canvas, paint);
    } else if (svgPath.contains('M15 10L19.553')) {
      _drawVideo(canvas, paint);
    } else if (svgPath.contains('M9 18V5L21 3V16')) {
      _drawAudio(canvas, paint);
    } else if (svgPath.contains('M18 6L6 18M6 6L18 18')) {
      _drawClose(canvas, paint);
    } else if (svgPath.contains('M20 6L9 17L4 12')) {
      _drawCheck(canvas, paint);
    } else if (svgPath.contains('M12 5V19M5 12H19')) {
      _drawAdd(canvas, paint);
    } else if (svgPath.contains('M19 12H5M5 12L12 19')) {
      _drawBack(canvas, paint);
    } else if (svgPath.contains('M9 18L15 12L9 6')) {
      _drawChevronRight(canvas, paint);
    } else if (svgPath.contains('circle cx="12" cy="5" r="1.5"')) {
      _drawMore(canvas, paint);
    } else if (svgPath.contains('circle cx="11" cy="11" r="7"')) {
      _drawSearch(canvas, paint);
    } else if (svgPath.contains('M13 2L4.09 12.11')) {
      _drawLightning(canvas, paint);
    } else if (svgPath.contains('ellipse cx="12" cy="5"')) {
      _drawStorage(canvas, paint);
    } else if (svgPath.contains('M22 19C22 19.5304 21.7893 20.0391 21.4142')) {
      _drawFolder(canvas, paint);
    } else if (svgPath.contains('M15 3H21V9')) {
      _drawOpen(canvas, paint);
    } else if (svgPath.contains('M3 6H21M8 6V4')) {
      _drawDelete(canvas, paint);
    } else if (svgPath.contains('circle cx="18" cy="5" r="3"')) {
      _drawShare(canvas, paint);
    } else if (svgPath.contains('M18 8C18 6.4087')) {
      _drawNotification(canvas, paint);
    } else if (svgPath.contains('M12 2C6.47715')) {
      _drawSpeed(canvas, paint);
    } else if (svgPath.contains('M12 22C12 22 4 18 4 12')) {
      _drawSecurity(canvas, paint);
    } else if (svgPath.contains('circle cx="12" cy="12" r="10"')) {
      if (svgPath.contains('M10 8L16 12')) {
        _drawPlay(canvas, paint);
      } else if (svgPath.contains('M10 8V16M14 8V16')) {
        _drawPause(canvas, paint);
      } else {
        _drawInfo(canvas, paint);
      }
    } else if (svgPath.contains('M5 12.55')) {
      _drawWifi(canvas, paint);
    } else if (svgPath.contains('circle cx="12" cy="12" r="3"')) {
      _drawHotspot(canvas, paint);
    } else if (svgPath.contains('M3 9V4C3 3.44772')) {
      _drawScan(canvas, paint);
    } else if (svgPath.contains('rect x="3" y="3" width="7" height="7" rx="1"') && svgPath.contains('rect x="14" y="3"')) {
      if (svgPath.contains('path d="M14 14H16V16H14V14Z"')) {
        _drawQr(canvas, paint);
      } else {
        _drawGrid(canvas, paint);
      }
    } else if (svgPath.contains('M8 6H21M8 12H21M8 18H21')) {
      _drawList(canvas, paint);
    } else if (svgPath.contains('M10.29 3.86L1.82 18')) {
      _drawWarning(canvas, paint);
    } else if (svgPath.contains('M23 4V10H17')) {
      _drawRefresh(canvas, paint);
    } else if (svgPath.contains('M9 18V5L21 3V16')) {
      _drawAudio(canvas, paint);
    } else if (svgPath.contains('rect x="9" y="9" width="13"')) {
      _drawCopy(canvas, paint);
    } else if (svgPath.contains('M11 4H4C3.44772')) {
      _drawEdit(canvas, paint);
    } else if (svgPath.contains('M22 3H2L10 12.46')) {
      _drawFilter(canvas, paint);
    } else if (svgPath.contains('M3 6H21M6 12H18')) {
      _drawSort(canvas, paint);
    } else if (svgPath.contains('rect x="5" y="2" width="14"')) {
      _drawPhone(canvas, paint);
    } else if (svgPath.contains('rect x="2" y="3" width="20"')) {
      _drawLaptop(canvas, paint);
    } else if (svgPath.contains('M12 2C12 2 8 7 8 12')) {
      _drawLanguage(canvas, paint);
    } else if (svgPath.contains('circle cx="8.5" cy="8.5" r="1.5"')) {
      _drawImage(canvas, paint);
    } else if (svgPath.contains('M14 2H6C4.89543 2 4 2.89543 4 4V20') && svgPath.contains('M16 13H8')) {
      _drawDocument(canvas, paint);
    } else if (svgPath.contains('rect x="5" y="2"') && svgPath.contains('circle cx="12" cy="17"')) {
      _drawApk(canvas, paint);
    } else if (svgPath.contains('M21 8V21H3V8')) {
      _drawArchive(canvas, paint);
    } else if (svgPath.contains('M12 2V4M12 20V22')) {
      _drawTheme(canvas, paint);
    } else {
      _drawDefault(canvas, paint);
    }
  }

  void _drawSend(Canvas c, Paint p) {
    c.drawLine(const Offset(22, 2), const Offset(11, 13), p);
    final path = Path()
      ..moveTo(22, 2)
      ..lineTo(15, 22)
      ..lineTo(11, 13)
      ..lineTo(2, 9)
      ..close();
    c.drawPath(path, p);
  }

  void _drawReceive(Canvas c, Paint p) {
    c.drawLine(const Offset(12, 2), const Offset(12, 16), p);
    c.drawLine(const Offset(12, 16), const Offset(8, 12), p);
    c.drawLine(const Offset(12, 16), const Offset(16, 12), p);
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTRB(2, 17, 22, 21),
      const Radius.circular(1),
    );
    c.drawRRect(rrect, p..style = PaintingStyle.stroke);
  }

  void _drawArrow(Canvas c, Paint p) {
    c.drawLine(const Offset(5, 12), const Offset(19, 12), p);
    c.drawLine(const Offset(19, 12), const Offset(13, 6), p);
    c.drawLine(const Offset(19, 12), const Offset(13, 18), p);
  }

  void _drawHome(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(3, 9.5)
      ..lineTo(12, 3)
      ..lineTo(21, 9.5)
      ..lineTo(21, 20)
      ..lineTo(15, 20)
      ..lineTo(15, 15)
      ..lineTo(9, 15)
      ..lineTo(9, 20)
      ..lineTo(3, 20)
      ..close();
    c.drawPath(path, p);
  }

  void _drawHistory(Canvas c, Paint p) {
    c.drawLine(const Offset(12, 8), const Offset(12, 12), p);
    c.drawLine(const Offset(12, 12), const Offset(15, 15), p);
    c.drawCircle(const Offset(12, 12), 9, p);
  }

  void _drawSettings(Canvas c, Paint p) {
    c.drawCircle(const Offset(12, 12), 3, p);
    // Draw gear teeth simplified
    for (int i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      final inner = Offset(12 + 5.5 * cos(angle), 12 + 5.5 * sin(angle));
      final outer = Offset(12 + 7.5 * cos(angle), 12 + 7.5 * sin(angle));
      c.drawLine(inner, outer, p..strokeWidth = 2.5);
    }
  }

  void _drawProfile(Canvas c, Paint p) {
    c.drawCircle(const Offset(12, 7), 4, p);
    final path = Path()
      ..moveTo(4, 21)
      ..lineTo(4, 19)
      ..quadraticBezierTo(4, 15, 8, 15)
      ..lineTo(16, 15)
      ..quadraticBezierTo(20, 15, 20, 19)
      ..lineTo(20, 21);
    c.drawPath(path, p);
  }

  void _drawFile(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(14, 2)
      ..lineTo(6, 2)
      ..quadraticBezierTo(4, 2, 4, 4)
      ..lineTo(4, 20)
      ..quadraticBezierTo(4, 22, 6, 22)
      ..lineTo(18, 22)
      ..quadraticBezierTo(20, 22, 20, 20)
      ..lineTo(20, 8)
      ..close();
    c.drawPath(path, p);
    c.drawLine(const Offset(14, 2), const Offset(14, 8), p);
    c.drawLine(const Offset(14, 8), const Offset(20, 8), p);
  }

  void _drawImage(Canvas c, Paint p) {
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTRB(3, 3, 21, 21),
      const Radius.circular(2),
    );
    c.drawRRect(rrect, p);
    c.drawCircle(const Offset(8.5, 8.5), 1.5, p..style = PaintingStyle.fill);
    p.style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(21, 15)
      ..lineTo(16, 10)
      ..lineTo(5, 21);
    c.drawPath(path, p);
  }

  void _drawVideo(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(15, 10)
      ..lineTo(21, 7)
      ..lineTo(21, 17)
      ..lineTo(15, 14)
      ..close();
    c.drawPath(path, p);
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTRB(2, 7, 15, 17),
      const Radius.circular(2),
    );
    c.drawRRect(rrect, p);
  }

  void _drawAudio(Canvas c, Paint p) {
    c.drawLine(const Offset(9, 18), const Offset(9, 5), p);
    c.drawLine(const Offset(9, 5), const Offset(21, 3), p);
    c.drawLine(const Offset(21, 3), const Offset(21, 16), p);
    c.drawCircle(const Offset(6, 18), 3, p);
    c.drawCircle(const Offset(18, 16), 3, p);
  }

  void _drawDocument(Canvas c, Paint p) {
    _drawFile(c, p);
    c.drawLine(const Offset(8, 13), const Offset(16, 13), p);
    c.drawLine(const Offset(8, 17), const Offset(16, 17), p);
    c.drawLine(const Offset(8, 9), const Offset(10, 9), p);
  }

  void _drawApk(Canvas c, Paint p) {
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTRB(5, 2, 19, 22),
      const Radius.circular(2),
    );
    c.drawRRect(rrect, p);
    c.drawCircle(const Offset(12, 17), 1, p..style = PaintingStyle.fill);
    p.style = PaintingStyle.stroke;
    c.drawLine(const Offset(9, 6), const Offset(15, 6), p);
    c.drawLine(const Offset(9, 10), const Offset(13, 10), p);
  }

  void _drawArchive(Canvas c, Paint p) {
    c.drawLine(const Offset(21, 8), const Offset(21, 21), p);
    c.drawLine(const Offset(21, 21), const Offset(3, 21), p);
    c.drawLine(const Offset(3, 21), const Offset(3, 8), p);
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTRB(1, 3, 23, 8),
      const Radius.circular(0),
    );
    c.drawRRect(rrect, p);
    c.drawLine(const Offset(10, 12), const Offset(14, 12), p);
  }

  void _drawClose(Canvas c, Paint p) {
    c.drawLine(const Offset(18, 6), const Offset(6, 18), p);
    c.drawLine(const Offset(6, 6), const Offset(18, 18), p);
  }

  void _drawCheck(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(20, 6)
      ..lineTo(9, 17)
      ..lineTo(4, 12);
    c.drawPath(path, p..strokeWidth = 2.5);
  }

  void _drawAdd(Canvas c, Paint p) {
    c.drawLine(const Offset(12, 5), const Offset(12, 19), p..strokeWidth = 2.5);
    c.drawLine(const Offset(5, 12), const Offset(19, 12), p);
  }

  void _drawBack(Canvas c, Paint p) {
    c.drawLine(const Offset(19, 12), const Offset(5, 12), p);
    c.drawLine(const Offset(5, 12), const Offset(12, 19), p);
    c.drawLine(const Offset(5, 12), const Offset(12, 5), p);
  }

  void _drawChevronRight(Canvas c, Paint p) {
    c.drawLine(const Offset(9, 18), const Offset(15, 12), p);
    c.drawLine(const Offset(15, 12), const Offset(9, 6), p);
  }

  void _drawMore(Canvas c, Paint p) {
    c.drawCircle(const Offset(12, 5), 1.5, p..style = PaintingStyle.fill);
    c.drawCircle(const Offset(12, 12), 1.5, p);
    c.drawCircle(const Offset(12, 19), 1.5, p);
  }

  void _drawSearch(Canvas c, Paint p) {
    p.style = PaintingStyle.stroke;
    c.drawCircle(const Offset(11, 11), 7, p);
    c.drawLine(const Offset(21, 21), const Offset(16.5, 16.5), p);
  }

  void _drawLightning(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(13, 2)
      ..lineTo(4, 13)
      ..lineTo(11, 13)
      ..lineTo(11, 22)
      ..lineTo(20, 11)
      ..lineTo(13, 11)
      ..close();
    c.drawPath(path, p..style = PaintingStyle.fill);
  }

  void _drawStorage(Canvas c, Paint p) {
    final oval = Rect.fromCenter(center: const Offset(12, 5), width: 18, height: 6);
    c.drawOval(oval, p..style = PaintingStyle.stroke);
    c.drawLine(const Offset(3, 5), const Offset(3, 19), p);
    c.drawLine(const Offset(21, 5), const Offset(21, 19), p);
    final oval2 = Rect.fromCenter(center: const Offset(12, 19), width: 18, height: 6);
    c.drawOval(oval2, p);
    c.drawLine(const Offset(3, 12), const Offset(21, 12), p..strokeWidth = 1.5);
  }

  void _drawFolder(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(22, 8)
      ..quadraticBezierTo(22, 6, 20, 6)
      ..lineTo(11, 6)
      ..lineTo(9, 3)
      ..lineTo(4, 3)
      ..quadraticBezierTo(2, 3, 2, 5)
      ..lineTo(2, 19)
      ..quadraticBezierTo(2, 21, 4, 21)
      ..lineTo(20, 21)
      ..quadraticBezierTo(22, 21, 22, 19)
      ..close();
    c.drawPath(path, p);
  }

  void _drawOpen(Canvas c, Paint p) {
    c.drawLine(const Offset(18, 13), const Offset(18, 19), p);
    c.drawLine(const Offset(18, 19), const Offset(5, 19), p);
    c.drawLine(const Offset(5, 19), const Offset(5, 6), p);
    c.drawLine(const Offset(5, 6), const Offset(11, 6), p);
    c.drawLine(const Offset(15, 3), const Offset(21, 3), p);
    c.drawLine(const Offset(21, 3), const Offset(21, 9), p);
    c.drawLine(const Offset(10, 14), const Offset(21, 3), p);
  }

  void _drawDelete(Canvas c, Paint p) {
    c.drawLine(const Offset(3, 6), const Offset(21, 6), p);
    c.drawLine(const Offset(8, 6), const Offset(8, 4), p);
    c.drawLine(const Offset(8, 4), const Offset(16, 4), p);
    c.drawLine(const Offset(16, 4), const Offset(16, 6), p);
    final path = Path()
      ..moveTo(19, 6)
      ..lineTo(18, 20)
      ..quadraticBezierTo(18, 21, 17, 21)
      ..lineTo(7, 21)
      ..quadraticBezierTo(6, 21, 6, 20)
      ..lineTo(5, 6);
    c.drawPath(path, p);
  }

  void _drawShare(Canvas c, Paint p) {
    c.drawCircle(const Offset(18, 5), 3, p..style = PaintingStyle.stroke);
    c.drawCircle(const Offset(6, 12), 3, p);
    c.drawCircle(const Offset(18, 19), 3, p);
    c.drawLine(const Offset(8.59, 13.51), const Offset(15.42, 17.49), p);
    c.drawLine(const Offset(15.41, 6.51), const Offset(8.59, 10.49), p);
  }

  void _drawNotification(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(18, 8)
      ..quadraticBezierTo(18, 4, 12, 4)
      ..quadraticBezierTo(6, 4, 6, 8)
      ..lineTo(3, 17)
      ..lineTo(21, 17)
      ..close();
    c.drawPath(path, p);
    c.drawLine(const Offset(10.27, 21), const Offset(13.73, 21), p);
  }

  void _drawSpeed(Canvas c, Paint p) {
    c.drawCircle(const Offset(12, 12), 10, p..style = PaintingStyle.stroke);
    c.drawLine(const Offset(12, 12), const Offset(16.5, 7.5), p);
    c.drawCircle(const Offset(12, 12), 2, p..style = PaintingStyle.fill);
  }

  void _drawSecurity(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(12, 22)
      ..quadraticBezierTo(4, 17, 4, 12)
      ..lineTo(4, 5)
      ..lineTo(12, 2)
      ..lineTo(20, 5)
      ..lineTo(20, 12)
      ..quadraticBezierTo(20, 17, 12, 22);
    c.drawPath(path, p..style = PaintingStyle.stroke);
    c.drawLine(const Offset(9, 12), const Offset(11, 14), p);
    c.drawLine(const Offset(11, 14), const Offset(15, 10), p);
  }

  void _drawPlay(Canvas c, Paint p) {
    c.drawCircle(const Offset(12, 12), 10, p..style = PaintingStyle.stroke);
    final triangle = Path()
      ..moveTo(10, 8)
      ..lineTo(16, 12)
      ..lineTo(10, 16)
      ..close();
    c.drawPath(triangle, p..style = PaintingStyle.fill);
  }

  void _drawPause(Canvas c, Paint p) {
    c.drawCircle(const Offset(12, 12), 10, p..style = PaintingStyle.stroke);
    c.drawLine(const Offset(10, 8), const Offset(10, 16), p..strokeWidth = 2.5);
    c.drawLine(const Offset(14, 8), const Offset(14, 16), p);
  }

  void _drawInfo(Canvas c, Paint p) {
    p.style = PaintingStyle.stroke;
    c.drawCircle(const Offset(12, 12), 10, p);
    c.drawLine(const Offset(12, 16), const Offset(12, 12), p);
    c.drawCircle(const Offset(12, 8), 0.5, p..style = PaintingStyle.fill);
  }

  void _drawWifi(Canvas c, Paint p) {
    c.drawLine(const Offset(5, 12.55), const Offset(20, 12.55), p);
    c.drawLine(const Offset(1.5, 8.5), const Offset(23.5, 8.5), p);
    c.drawLine(const Offset(8.5, 16.5), const Offset(16.5, 16.5), p);
    c.drawCircle(const Offset(12.5, 20), 1, p..style = PaintingStyle.fill);
  }

  void _drawHotspot(Canvas c, Paint p) {
    p.style = PaintingStyle.stroke;
    c.drawCircle(const Offset(12, 12), 3, p);
    final path1 = Path()
      ..moveTo(6.34, 6.34)
      ..quadraticBezierTo(4, 8.5, 4, 12)
      ..quadraticBezierTo(4, 15.5, 6.34, 17.66);
    c.drawPath(path1, p);
    final path2 = Path()
      ..moveTo(17.66, 6.34)
      ..quadraticBezierTo(20, 8.5, 20, 12)
      ..quadraticBezierTo(20, 15.5, 17.66, 17.66);
    c.drawPath(path2, p);
  }

  void _drawScan(Canvas c, Paint p) {
    c.drawLine(const Offset(3, 9), const Offset(3, 4), p);
    c.drawLine(const Offset(3, 4), const Offset(9, 4), p);
    c.drawLine(const Offset(21, 9), const Offset(21, 4), p);
    c.drawLine(const Offset(21, 4), const Offset(15, 4), p);
    c.drawLine(const Offset(3, 15), const Offset(3, 20), p);
    c.drawLine(const Offset(3, 20), const Offset(9, 20), p);
    c.drawLine(const Offset(21, 15), const Offset(21, 20), p);
    c.drawLine(const Offset(21, 20), const Offset(15, 20), p);
    c.drawLine(const Offset(2, 12), const Offset(22, 12), p);
  }

  void _drawQr(Canvas c, Paint p) {
    _drawGrid(c, p);
  }

  void _drawGrid(Canvas c, Paint p) {
    final r1 = RRect.fromRectAndRadius(const Rect.fromLTRB(3, 3, 10, 10), const Radius.circular(1));
    final r2 = RRect.fromRectAndRadius(const Rect.fromLTRB(14, 3, 21, 10), const Radius.circular(1));
    final r3 = RRect.fromRectAndRadius(const Rect.fromLTRB(3, 14, 10, 21), const Radius.circular(1));
    final r4 = RRect.fromRectAndRadius(const Rect.fromLTRB(14, 14, 21, 21), const Radius.circular(1));
    p.style = PaintingStyle.stroke;
    c.drawRRect(r1, p);
    c.drawRRect(r2, p);
    c.drawRRect(r3, p);
    c.drawRRect(r4, p);
  }

  void _drawList(Canvas c, Paint p) {
    c.drawLine(const Offset(8, 6), const Offset(21, 6), p);
    c.drawLine(const Offset(8, 12), const Offset(21, 12), p);
    c.drawLine(const Offset(8, 18), const Offset(21, 18), p);
    c.drawCircle(const Offset(3, 6), 0.8, p..style = PaintingStyle.fill);
    c.drawCircle(const Offset(3, 12), 0.8, p);
    c.drawCircle(const Offset(3, 18), 0.8, p);
  }

  void _drawWarning(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(10.29, 3.86)
      ..lineTo(1.82, 18)
      ..quadraticBezierTo(1, 21, 3.53, 21)
      ..lineTo(20.47, 21)
      ..quadraticBezierTo(23, 21, 22.18, 18)
      ..lineTo(13.71, 3.86)
      ..quadraticBezierTo(12, 1, 10.29, 3.86)
      ..close();
    p.style = PaintingStyle.stroke;
    c.drawPath(path, p);
    c.drawLine(const Offset(12, 9), const Offset(12, 13), p);
    c.drawCircle(const Offset(12, 17), 0.5, p..style = PaintingStyle.fill);
  }

  void _drawRefresh(Canvas c, Paint p) {
    c.drawLine(const Offset(23, 4), const Offset(23, 10), p);
    c.drawLine(const Offset(23, 10), const Offset(17, 10), p);
    final path = Path()
      ..moveTo(20.49, 15)
      ..quadraticBezierTo(17, 22, 12, 21)
      ..quadraticBezierTo(4, 19, 4, 12)
      ..quadraticBezierTo(4, 5, 12, 3)
      ..quadraticBezierTo(17, 3, 19.7, 7.8);
    c.drawPath(path, p);
  }

  void _drawCopy(Canvas c, Paint p) {
    final r1 = RRect.fromRectAndRadius(const Rect.fromLTRB(9, 9, 22, 22), const Radius.circular(2));
    c.drawRRect(r1, p..style = PaintingStyle.stroke);
    final path = Path()
      ..moveTo(5, 15)
      ..lineTo(4, 15)
      ..quadraticBezierTo(2, 15, 2, 13)
      ..lineTo(2, 4)
      ..quadraticBezierTo(2, 2, 4, 2)
      ..lineTo(13, 2)
      ..quadraticBezierTo(15, 2, 15, 4)
      ..lineTo(15, 5);
    c.drawPath(path, p);
  }

  void _drawEdit(Canvas c, Paint p) {
    final path1 = Path()
      ..moveTo(11, 4)
      ..lineTo(4, 4)
      ..quadraticBezierTo(3, 4, 3, 5)
      ..lineTo(3, 20)
      ..quadraticBezierTo(3, 21, 4, 21)
      ..lineTo(19, 21)
      ..quadraticBezierTo(20, 21, 20, 20)
      ..lineTo(20, 13);
    c.drawPath(path1, p..style = PaintingStyle.stroke);
    final path2 = Path()
      ..moveTo(18.5, 2.5)
      ..quadraticBezierTo(20, 2.5, 21, 4)
      ..lineTo(12, 13)
      ..lineTo(9, 14)
      ..lineTo(10, 11)
      ..close();
    c.drawPath(path2, p);
  }

  void _drawFilter(Canvas c, Paint p) {
    final path = Path()
      ..moveTo(22, 3)
      ..lineTo(2, 3)
      ..lineTo(10, 12.46)
      ..lineTo(10, 19)
      ..lineTo(14, 21)
      ..lineTo(14, 12.46)
      ..close();
    c.drawPath(path, p..style = PaintingStyle.stroke);
  }

  void _drawSort(Canvas c, Paint p) {
    c.drawLine(const Offset(3, 6), const Offset(21, 6), p);
    c.drawLine(const Offset(6, 12), const Offset(18, 12), p);
    c.drawLine(const Offset(10, 18), const Offset(14, 18), p);
  }

  void _drawPhone(Canvas c, Paint p) {
    final r = RRect.fromRectAndRadius(const Rect.fromLTRB(5, 2, 19, 22), const Radius.circular(2));
    c.drawRRect(r, p..style = PaintingStyle.stroke);
    c.drawCircle(const Offset(12, 18), 1, p..style = PaintingStyle.fill);
  }

  void _drawLaptop(Canvas c, Paint p) {
    final r = RRect.fromRectAndRadius(const Rect.fromLTRB(2, 3, 22, 17), const Radius.circular(2));
    c.drawRRect(r, p..style = PaintingStyle.stroke);
    c.drawLine(const Offset(1, 21), const Offset(23, 21), p);
  }

  void _drawLanguage(Canvas c, Paint p) {
    c.drawCircle(const Offset(12, 12), 10, p..style = PaintingStyle.stroke);
    c.drawLine(const Offset(2, 12), const Offset(22, 12), p);
    final path = Path()
      ..moveTo(12, 2)
      ..quadraticBezierTo(8, 7, 8, 12)
      ..quadraticBezierTo(8, 17, 12, 22);
    c.drawPath(path, p);
    final path2 = Path()
      ..moveTo(12, 2)
      ..quadraticBezierTo(16, 7, 16, 12)
      ..quadraticBezierTo(16, 17, 12, 22);
    c.drawPath(path2, p);
  }

  void _drawTheme(Canvas c, Paint p) {
    c.drawCircle(const Offset(12, 12), 4, p..style = PaintingStyle.stroke);
    for (int i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      final inner = Offset(12 + 6 * cos(angle), 12 + 6 * sin(angle));
      final outer = Offset(12 + 9 * cos(angle), 12 + 9 * sin(angle));
      c.drawLine(inner, outer, p);
    }
  }

  void _drawDefault(Canvas c, Paint p) {
    // Render a simple circle as fallback
    c.drawCircle(const Offset(12, 12), 8, p..style = PaintingStyle.stroke);
  }

  double cos(double angle) => _cos(angle);
  double sin(double angle) => _sin(angle);
  
  double _cos(double x) {
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / (2 * i * (2 * i - 1));
      result += term;
    }
    return result;
  }
  
  double _sin(double x) {
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i + 1) * 2 * i);
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.color != color || old.svgPath != svgPath;
}
