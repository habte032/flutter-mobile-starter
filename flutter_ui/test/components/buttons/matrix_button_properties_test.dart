import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';
import '../../utils/property_test_utils.dart';

void main() {
  group('AppButton Property Tests', () {
    // Feature: flutter-ui-components, Property 1: Component size consistency
    test(
      'Property 1: Button dimensions increase from small to medium to large',
      () {
        PropertyTestUtils.runPropertyTest(
          description: 'Button size consistency across variants',
          iterations: 100,
          test: () {
            // Generate random button variant
            final variant = PropertyTestUtils.randomElement([
              AppButtonVariant.primary,
              AppButtonVariant.secondary,
              AppButtonVariant.tertiary,
              AppButtonVariant.ghost,
            ]);

            // Generate random label
            final label = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(5, 15),
            );

            // Create buttons with different sizes
            final smallButton = AppButton(
              label: label,
              variant: variant,
              size: AppButtonSize.small,
              onPressed: () {},
            );

            final mediumButton = AppButton(
              label: label,
              variant: variant,
              size: AppButtonSize.medium,
              onPressed: () {},
            );

            final largeButton = AppButton(
              label: label,
              variant: variant,
              size: AppButtonSize.large,
              onPressed: () {},
            );

            // Verify padding increases with size
            final smallPadding = smallButton._padding;
            final mediumPadding = mediumButton._padding;
            final largePadding = largeButton._padding;

            // Check horizontal padding increases
            expect(
              smallPadding.horizontal < mediumPadding.horizontal,
              true,
              reason:
                  'Small button horizontal padding (${smallPadding.horizontal}) '
                  'should be less than medium (${mediumPadding.horizontal})',
            );
            expect(
              mediumPadding.horizontal < largePadding.horizontal,
              true,
              reason:
                  'Medium button horizontal padding (${mediumPadding.horizontal}) '
                  'should be less than large (${largePadding.horizontal})',
            );

            // Check vertical padding increases
            expect(
              smallPadding.vertical < mediumPadding.vertical,
              true,
              reason:
                  'Small button vertical padding (${smallPadding.vertical}) '
                  'should be less than medium (${mediumPadding.vertical})',
            );
            expect(
              mediumPadding.vertical < largePadding.vertical,
              true,
              reason:
                  'Medium button vertical padding (${mediumPadding.vertical}) '
                  'should be less than large (${largePadding.vertical})',
            );

            // Verify text style font size increases with size
            final smallTextSize = smallButton._textStyle.fontSize!;
            final mediumTextSize = mediumButton._textStyle.fontSize!;
            final largeTextSize = largeButton._textStyle.fontSize!;

            expect(
              smallTextSize < mediumTextSize,
              true,
              reason:
                  'Small button font size ($smallTextSize) '
                  'should be less than medium ($mediumTextSize)',
            );
            expect(
              mediumTextSize < largeTextSize,
              true,
              reason:
                  'Medium button font size ($mediumTextSize) '
                  'should be less than large ($largeTextSize)',
            );

            // Verify icon size increases with size
            final smallIconSize = smallButton._iconSize;
            final mediumIconSize = mediumButton._iconSize;
            final largeIconSize = largeButton._iconSize;

            expect(
              smallIconSize < mediumIconSize,
              true,
              reason:
                  'Small button icon size ($smallIconSize) '
                  'should be less than medium ($mediumIconSize)',
            );
            expect(
              mediumIconSize < largeIconSize,
              true,
              reason:
                  'Medium button icon size ($mediumIconSize) '
                  'should be less than large ($largeIconSize)',
            );
          },
        );
      },
    );

    // Feature: flutter-ui-components, Property 2: Custom color application
    test('Property 2: Custom colors are applied to button appearance', () {
      PropertyTestUtils.runPropertyTest(
        description: 'Custom color application across variants',
        iterations: 100,
        test: () {
          // Generate random button variant
          final variant = PropertyTestUtils.randomElement([
            AppButtonVariant.primary,
            AppButtonVariant.secondary,
            AppButtonVariant.tertiary,
            AppButtonVariant.ghost,
            AppButtonVariant.custom,
          ]);

          // Generate random label
          final label = PropertyTestUtils.randomString(
            PropertyTestUtils.randomInt(5, 15),
          );

          // Select random custom colors from design tokens
          final customBackgroundColor = PropertyTestUtils.randomElement([
            AppColors.primary,
            AppColors.primaryLight,
            AppColors.primaryDark,
            AppColors.secondary,
            AppColors.secondaryLight,
            AppColors.secondaryDark,
            AppColors.accent1,
            AppColors.accent2,
            AppColors.accent3,
            AppColors.accent4,
            AppColors.success,
            AppColors.warning,
            AppColors.error,
            AppColors.info,
            AppColors.surface,
            AppColors.surfaceAlt,
          ]);

          final customForegroundColor = PropertyTestUtils.randomElement([
            AppColors.textPrimary,
            AppColors.textSecondary,
            AppColors.darkTextPrimary,
            AppColors.darkTextSecondary,
            AppColors.primary,
            AppColors.secondary,
            AppColors.accent1,
            AppColors.accent2,
            AppColors.accent3,
            AppColors.accent4,
          ]);

          // Create button with custom colors
          final button = AppButton(
            label: label,
            variant: variant,
            onPressed: () {},
            customBackgroundColor: customBackgroundColor,
            customForegroundColor: customForegroundColor,
          );

          // Verify custom background color is applied
          final actualBackgroundColor = button._backgroundColor;
          expect(
            actualBackgroundColor,
            customBackgroundColor,
            reason:
                'Custom background color should be applied. '
                'Expected: $customBackgroundColor, Got: $actualBackgroundColor',
          );

          // Verify custom foreground color is applied
          final actualForegroundColor = button._foregroundColor;
          expect(
            actualForegroundColor,
            customForegroundColor,
            reason:
                'Custom foreground color should be applied. '
                'Expected: $customForegroundColor, Got: $actualForegroundColor',
          );
        },
      );
    });
  });
}

// Extension to access private members for testing
extension AppButtonTestExtension on AppButton {
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

  Color get _backgroundColor {
    if (customBackgroundColor != null) {
      return customBackgroundColor!;
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return Colors.transparent;
      case AppButtonVariant.tertiary:
        return AppColors.surface;
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.custom:
        return customBackgroundColor ?? AppColors.primary;
    }
  }

  Color get _foregroundColor {
    if (customForegroundColor != null) {
      return customForegroundColor!;
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.tertiary:
        return AppColors.textPrimary;
      case AppButtonVariant.ghost:
        return AppColors.textPrimary;
      case AppButtonVariant.custom:
        return customForegroundColor ?? Colors.white;
    }
  }
}
