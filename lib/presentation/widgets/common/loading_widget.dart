import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/theme_helper.dart';

class LoadingWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingText;
  final Color? backgroundColor;
  final Color? loadingColor;

  const LoadingWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText,
    this.backgroundColor,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? th.overlay,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: th.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: th.shadowMedium,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        loadingColor ?? AppColors.primaryColor,
                      ),
                    ),
                    if (loadingText != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        loadingText!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: th.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Simple loading overlay for minimal loading states
class SimpleLoadingWidget extends StatelessWidget {
  final bool isLoading;
  final Color? loadingColor;

  const SimpleLoadingWidget({
    super.key,
    required this.isLoading,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: th.overlay,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            loadingColor ?? AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}

/// Loading button with integrated loading state
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: th.subtleBackground,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
