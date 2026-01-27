import 'package:flutter/material.dart';
import '../../config/constants/app_colors.dart';
import '../../config/constants/app_spacing.dart';
import '../../config/constants/app_radius.dart';
import '../../config/theme/app_typography.dart';

/// Enum defining the visual variants of AppButton
enum AppButtonVariant { primary, secondary, tertiary, ghost, custom }

/// Enum defining the size variants of AppButton
enum AppButtonSize { small, medium, large }

/// A customizable button component with multiple variants and states.
///
/// AppButton provides a consistent button interface with support for
/// different visual styles (variants), sizes, loading states, and custom colors.
///
/// Example usage:
/// ```dart
/// AppButton.primary(
///   label: 'Submit',
///   onPressed: () => print('Pressed'),
/// )
/// ```
class AppButton extends StatelessWidget {
  /// The text label displayed on the button
  final String label;

  /// Callback invoked when the button is pressed
  final VoidCallback? onPressed;

  /// The visual variant of the button
  final AppButtonVariant variant;

  /// The size variant of the button
  final AppButtonSize size;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Optional icon to display alongside the label
  final IconData? icon;

  /// Custom background color (overrides variant color)
  final Color? customBackgroundColor;

  /// Custom foreground color for text and icon (overrides variant color)
  final Color? customForegroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.customBackgroundColor,
    this.customForegroundColor,
  });

  /// Creates a primary button with filled background
  factory AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: size,
      isLoading: isLoading,
      icon: icon,
    );
  }

  /// Creates a secondary button with outlined style
  factory AppButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      size: size,
      isLoading: isLoading,
      icon: icon,
    );
  }

  /// Creates a tertiary button with subtle styling
  factory AppButton.tertiary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.tertiary,
      size: size,
      isLoading: isLoading,
      icon: icon,
    );
  }

  /// Creates a ghost button with transparent background
  factory AppButton.ghost({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.ghost,
      size: size,
      isLoading: isLoading,
      icon: icon,
    );
  }

  /// Creates an icon-only button
  factory AppButton.icon({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    AppButtonVariant variant = AppButtonVariant.primary,
  }) {
    return AppButton(
      key: key,
      label: '',
      onPressed: onPressed,
      variant: variant,
      size: size,
      isLoading: isLoading,
      icon: icon,
    );
  }

  /// Creates a custom button with specified colors
  factory AppButton.custom({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.custom,
      size: size,
      isLoading: isLoading,
      icon: icon,
      customBackgroundColor: backgroundColor,
      customForegroundColor: foregroundColor,
    );
  }

  /// Returns the padding based on button size
  EdgeInsets get _padding {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
    }
  }

  /// Returns the text style based on button size
  TextStyle get _textStyle {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.labelSmall;
      case AppButtonSize.medium:
        return AppTypography.labelMedium;
      case AppButtonSize.large:
        return AppTypography.labelLarge;
    }
  }

  /// Returns the icon size based on button size
  double get _iconSize {
    switch (size) {
      case AppButtonSize.small:
        return 16.0;
      case AppButtonSize.medium:
        return 20.0;
      case AppButtonSize.large:
        return 24.0;
    }
  }

  /// Returns the background color based on variant and state
  Color _backgroundColor(BuildContext context) {
    if (customBackgroundColor != null) {
      return customBackgroundColor!;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return Colors.transparent;
      case AppButtonVariant.tertiary:
        return isDark ? AppColors.darkSurface : AppColors.surface;
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.custom:
        return customBackgroundColor ?? AppColors.primary;
    }
  }

  /// Returns the foreground color based on variant and state
  Color _foregroundColor(BuildContext context) {
    if (customForegroundColor != null) {
      return customForegroundColor!;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return isDark
            ? Color(0xFF60A5FA)
            : AppColors.primary; // Brighter blue for dark mode
      case AppButtonVariant.tertiary:
        return isDark
            ? Color(0xFFE5E7EB)
            : AppColors.textPrimary; // Lighter gray for dark mode
      case AppButtonVariant.ghost:
        return isDark
            ? Color(0xFFE5E7EB)
            : AppColors.textPrimary; // Lighter gray for dark mode
      case AppButtonVariant.custom:
        return customForegroundColor ?? Colors.white;
    }
  }

  /// Returns the border side based on variant
  BorderSide? _borderSide(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.secondary:
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return BorderSide(
          color:
              customForegroundColor ??
              (isDark
                  ? Color(0xFF60A5FA)
                  : AppColors.primary), // Brighter blue for dark mode
          width: 1.5,
        );
      case AppButtonVariant.primary:
      case AppButtonVariant.tertiary:
      case AppButtonVariant.ghost:
      case AppButtonVariant.custom:
        return null;
    }
  }

  /// Determines if the button is disabled
  bool get _isDisabled => onPressed == null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isIconOnly = label.isEmpty && icon != null;
    final foregroundColor = _foregroundColor(context);
    final borderSide = _borderSide(context);
    final backgroundColor = _backgroundColor(context);

    return Semantics(
      button: true,
      enabled: !_isDisabled && !isLoading,
      label: label.isNotEmpty ? label : null,
      hint: isLoading ? 'Loading' : null,
      child: Opacity(
        opacity: _isDisabled ? 0.5 : 1.0,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 44.0,
                minHeight: 44.0,
              ),
              padding: _padding,
              decoration: BoxDecoration(
                border: borderSide != null
                    ? Border.all(
                        color: borderSide.color,
                        width: borderSide.width,
                      )
                    : null,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisSize: isIconOnly ? MainAxisSize.min : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          foregroundColor,
                        ),
                      ),
                    )
                  else ...[
                    if (icon != null) ...[
                      Icon(icon, size: _iconSize, color: foregroundColor),
                      if (label.isNotEmpty)
                        const SizedBox(width: AppSpacing.sm),
                    ],
                    if (label.isNotEmpty)
                      Text(
                        label,
                        style: _textStyle.copyWith(color: foregroundColor),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
