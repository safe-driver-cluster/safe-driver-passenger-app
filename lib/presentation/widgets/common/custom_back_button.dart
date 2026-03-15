import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final double size;

  const CustomBackButton({
    super.key,
    this.color = Colors.white,
    this.backgroundColor,
    this.onPressed,
    this.size = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    // Automatically determine a suitable background color if not provided
    final isWhite = color == Colors.white;
    final defaultBg = isWhite
        ? Colors.white.withOpacity(0.25)
        : Colors.black.withOpacity(0.05);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (color ?? Colors.white).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.arrow_back,
          size: size,
          color: color,
        ),
        onPressed: onPressed ?? () => Navigator.pop(context),
      ),
    );
  }
}
