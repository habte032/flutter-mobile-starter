import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

/// Reusable button component with different styles
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonStyle style;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.style = AppButtonStyle.primary,
    this.width,
    this.height,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final content = _buildContent(context);

    Widget button;
    switch (style) {
      case AppButtonStyle.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: content,
        );
        break;
      case AppButtonStyle.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: content,
        );
        break;
      case AppButtonStyle.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: content,
        );
        break;
    }

    if (width != null) {
      return SizedBox(
        width: width,
        child: button,
      );
    }

    return button;
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = theme.textTheme.bodyLarge ?? const TextStyle();
    
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? _getDefaultTextColorForContext(context),
          ),
        ),
      );
    }

    final textStyle = (textColor != null || fontSize != null)
        ? defaultTextStyle.copyWith(
            color: textColor ?? _getDefaultTextColorForContext(context),
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
          )
        : theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.2,
          ) ?? defaultTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.2,
          );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: fontSize != null ? fontSize! + 4 : 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: textStyle,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: textStyle,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.center,
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final bgColor = backgroundColor ?? _getDefaultBackgroundColor();
    final txtColor = textColor ?? _getDefaultTextColor();
    final buttonPadding = padding ?? const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 16,
    );
    final minHeight = height ?? 48.0;

    switch (style) {
      case AppButtonStyle.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: txtColor,
          padding: buttonPadding,
          minimumSize: Size(0, minHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      case AppButtonStyle.secondary:
        return OutlinedButton.styleFrom(
          foregroundColor: txtColor,
          side: BorderSide(color: bgColor, width: 2),
          padding: buttonPadding,
          minimumSize: Size(0, minHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      case AppButtonStyle.text:
        return TextButton.styleFrom(
          foregroundColor: txtColor,
          padding: buttonPadding,
          minimumSize: Size(0, minHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
    }
  }

  Color _getDefaultBackgroundColor() {
    switch (style) {
      case AppButtonStyle.primary:
        return AppColors.primary;
      case AppButtonStyle.secondary:
        return AppColors.primary;
      case AppButtonStyle.text:
        return AppColors.transparent;
    }
  }

  Color _getDefaultTextColor() {
    switch (style) {
      case AppButtonStyle.primary:
        return AppColors.white;
      case AppButtonStyle.secondary:
        return AppColors.primary;
      case AppButtonStyle.text:
        return AppColors.primary;
    }
  }

  Color _getDefaultTextColorForContext(BuildContext context) {
    switch (style) {
      case AppButtonStyle.primary:
        return Theme.of(context).colorScheme.onPrimary;
      case AppButtonStyle.secondary:
        return Theme.of(context).colorScheme.primary;
      case AppButtonStyle.text:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

/// Button style variants
enum AppButtonStyle {
  primary,
  secondary,
  text,
}

