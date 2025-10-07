import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class ProfessionalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? borderRadius;
  final List<BoxShadow>? shadows;
  final Border? border;
  final bool isGlass;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ProfessionalCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
    this.shadows,
    this.border,
    this.isGlass = false,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppDesign.spaceLG),
      margin: margin,
      decoration: BoxDecoration(
        color: isGlass ? null : (backgroundColor ?? AppColors.cardColor),
        gradient: isGlass ? AppColors.glassGradient : gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? AppDesign.radiusXL),
        boxShadow:
            shadows ?? (isGlass ? AppDesign.glassShadow : AppDesign.shadowMD),
        border: border ??
            (isGlass
                ? Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.0,
                  )
                : null),
      ),
      child: isGlass
          ? BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: AppDesign.blurStrength,
                  sigmaY: AppDesign.blurStrength),
              child: child,
            )
          : child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

class ProfessionalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool isText;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Gradient? gradient;

  const ProfessionalButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isText = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.borderRadius,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    if (gradient != null) {
      return Container(
        width: width,
        height: height ?? AppDesign.buttonHeightMD,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
          boxShadow: AppDesign.shadowSM,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius:
                BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spaceLG,
                vertical: AppDesign.spaceMD,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else if (icon != null)
                    icon!,
                  if ((isLoading || icon != null) && text.isNotEmpty)
                    const SizedBox(width: AppDesign.spaceSM),
                  if (text.isNotEmpty)
                    Text(
                      text,
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: foregroundColor ?? Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (isText) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(width ?? 0, height ?? AppDesign.buttonHeightMD),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
          ),
        ).merge(style),
        child: _buildButtonContent(),
      );
    }

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(width ?? 0, height ?? AppDesign.buttonHeightMD),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor ?? AppColors.primaryColor,
          side: BorderSide(color: foregroundColor ?? AppColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
          ),
        ).merge(style),
        child: _buildButtonContent(),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 0, height ?? AppDesign.buttonHeightMD),
        backgroundColor: backgroundColor ?? AppColors.primaryColor,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
        ),
      ).merge(style),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        else if (icon != null)
          icon!,
        if ((isLoading || icon != null) && text.isNotEmpty)
          const SizedBox(width: AppDesign.spaceSM),
        if (text.isNotEmpty)
          Text(
            text,
            style: AppTextStyles.buttonMedium,
          ),
      ],
    );
  }
}

class ProfessionalTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final bool filled;
  final Color? fillColor;
  final double? borderRadius;

  const ProfessionalTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.filled = true,
    this.fillColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: filled,
        fillColor: fillColor ?? AppColors.greyExtraLight,
        labelStyle: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDesign.radiusLG),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceLG,
          vertical: AppDesign.spaceMD,
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.textColor,
    this.fontSize,
    this.padding,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceMD,
            vertical: AppDesign.spaceXS,
          ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppDesign.spaceXS),
          ],
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor ?? color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
