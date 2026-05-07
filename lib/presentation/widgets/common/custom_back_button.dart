import 'package:flutter/material.dart';
import '../../../core/utils/theme_helper.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final double size;

  const CustomBackButton({
    super.key,
    this.color,
    this.backgroundColor,
    this.onPressed,
    this.size = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final resolvedColor = color ?? th.textPrimary;
    final defaultBg = th.isDark
        ? Colors.white.withOpacity(0.1)
        : resolvedColor.withOpacity(0.08);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: resolvedColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.arrow_back,
          size: size,
          color: resolvedColor,
        ),
        onPressed: onPressed ?? () => Navigator.pop(context),
      ),
    );
  }
}
