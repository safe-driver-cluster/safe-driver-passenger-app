import 'package:flutter/material.dart';

class GoogleIcon extends StatelessWidget {
  final double size;

  const GoogleIcon({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _GoogleIconPainter(),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Google G colors
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    // White circle background
    paint.color = Colors.white;
    canvas.drawCircle(center, radius, paint);

    // Blue section (right part)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      -1.5708, // Start at top
      1.5708, // Quarter circle
      true,
      paint,
    );

    // Red section (top left)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      -3.14159, // Start at left
      1.5708, // Quarter circle
      true,
      paint,
    );

    // Yellow section (bottom left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      -1.5708, // Start at bottom
      1.5708, // Quarter circle
      true,
      paint,
    );

    // Green section (bottom right)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      0, // Start at right
      1.5708, // Quarter circle
      true,
      paint,
    );

    // White G shape in center
    paint.color = Colors.white;
    final Path gPath = Path();
    gPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: radius * 0.6,
          height: radius * 0.6,
        ),
        Radius.circular(radius * 0.1),
      ),
    );
    canvas.drawPath(gPath, paint);

    // G letter shape
    paint.color = const Color(0xFF4285F4);
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'G',
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF4285F4),
          fontFamily: 'Roboto',
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
