import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';
import '../../utils/property_test_utils.dart';

void main() {
  group('AppCheckbox Property Tests', () {
    // Feature: flutter-ui-components, Property 14: Checkbox label tap area
    testWidgets(
      'Property 14: Tapping anywhere in checkbox row toggles checkbox state',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description: 'Checkbox label tap area across variants',
          iterations: 100,
          test: () async {
            // Generate random checkbox variant
            final variant = PropertyTestUtils.randomElement([
              AppCheckboxVariant.primary,
              AppCheckboxVariant.secondary,
              AppCheckboxVariant.compact,
            ]);

            // Generate random label
            final label = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(5, 20),
            );

            // Generate random initial value
            bool currentValue = PropertyTestUtils.randomBool();
            final initialValue = currentValue;

            // Build the checkbox with a label
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: StatefulBuilder(
                    builder: (context, setState) {
                      return AppCheckbox(
                        label: label,
                        value: currentValue,
                        variant: variant,
                        onChanged: (value) {
                          setState(() {
                            currentValue = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            );

            await tester.pumpAndSettle();

            // Verify the checkbox and label are rendered
            expect(find.text(label), findsOneWidget);
            expect(find.byType(Checkbox), findsOneWidget);

            // Find the InkWell that wraps the entire row
            final inkWellFinder = find.byType(InkWell);
            expect(inkWellFinder, findsOneWidget);

            // Tap the label text (not the checkbox itself)
            await tester.tap(find.text(label));
            await tester.pumpAndSettle();

            // Verify the value toggled
            expect(
              currentValue,
              !initialValue,
              reason:
                  'Tapping the label should toggle checkbox from $initialValue to ${!initialValue}',
            );

            // Reset for next test
            currentValue = PropertyTestUtils.randomBool();
            final secondInitialValue = currentValue;

            // Rebuild with new value
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: StatefulBuilder(
                    builder: (context, setState) {
                      return AppCheckbox(
                        label: label,
                        value: currentValue,
                        variant: variant,
                        onChanged: (value) {
                          setState(() {
                            currentValue = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            );

            await tester.pumpAndSettle();

            // Tap the InkWell directly (anywhere in the row)
            await tester.tap(inkWellFinder);
            await tester.pumpAndSettle();

            // Verify the value toggled again
            expect(
              currentValue,
              !secondInitialValue,
              reason:
                  'Tapping anywhere in the row should toggle checkbox from $secondInitialValue to ${!secondInitialValue}',
            );
          },
        );
      },
    );

    // Feature: flutter-ui-components, Property 15: Checkbox description display
    testWidgets('Property 15: Description text is visible below label', (
      WidgetTester tester,
    ) async {
      await PropertyTestUtils.runAsyncPropertyTest(
        description: 'Checkbox description display across variants',
        iterations: 100,
        test: () async {
          // Generate random checkbox variant
          final variant = PropertyTestUtils.randomElement([
            AppCheckboxVariant.primary,
            AppCheckboxVariant.secondary,
            AppCheckboxVariant.compact,
          ]);

          // Generate random label and description
          final label = PropertyTestUtils.randomString(
            PropertyTestUtils.randomInt(5, 20),
          );
          final description = PropertyTestUtils.randomString(
            PropertyTestUtils.randomInt(10, 50),
          );

          // Generate random value
          final value = PropertyTestUtils.randomBool();

          // Build the checkbox with label and description
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AppCheckbox(
                  label: label,
                  description: description,
                  value: value,
                  variant: variant,
                  onChanged: (_) {},
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Verify the label is rendered
          expect(
            find.text(label),
            findsOneWidget,
            reason: 'Label should be visible',
          );

          // Verify the description is rendered
          expect(
            find.text(description),
            findsOneWidget,
            reason: 'Description should be visible below label',
          );

          // Verify both checkbox and texts are present
          expect(find.byType(Checkbox), findsOneWidget);

          // Verify the description text widget exists and uses correct styling
          final descriptionTextFinder = find.text(description);
          expect(descriptionTextFinder, findsOneWidget);

          // Get the Text widget for the description
          final descriptionWidget = tester.widget<Text>(descriptionTextFinder);

          // Verify the description uses bodySmall style
          expect(
            descriptionWidget.style?.fontSize,
            AppTypography.bodySmall.fontSize,
            reason: 'Description should use bodySmall font size',
          );

          // Verify the description uses secondary text color (when enabled)
          expect(
            descriptionWidget.style?.color,
            AppColors.textSecondary,
            reason: 'Description should use secondary text color',
          );
        },
      );
    });

    // Feature: flutter-ui-components, Property 16: Checkbox disabled state
    testWidgets(
      'Property 16: Disabled checkbox has reduced opacity and no tap response',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description: 'Checkbox disabled state across variants',
          iterations: 100,
          test: () async {
            // Generate random checkbox variant
            final variant = PropertyTestUtils.randomElement([
              AppCheckboxVariant.primary,
              AppCheckboxVariant.secondary,
              AppCheckboxVariant.compact,
            ]);

            // Generate random label (or no label)
            final hasLabel = PropertyTestUtils.randomBool();
            final label = hasLabel
                ? PropertyTestUtils.randomString(
                    PropertyTestUtils.randomInt(5, 20),
                  )
                : null;

            // Generate random initial value
            bool currentValue = PropertyTestUtils.randomBool();
            final initialValue = currentValue;

            // Build the checkbox with onChanged=null (disabled)
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: StatefulBuilder(
                    builder: (context, setState) {
                      return AppCheckbox(
                        label: label,
                        value: currentValue,
                        variant: variant,
                        onChanged: null, // Disabled
                      );
                    },
                  ),
                ),
              ),
            );

            await tester.pumpAndSettle();

            // Verify the checkbox is rendered
            expect(find.byType(Checkbox), findsOneWidget);

            // Verify reduced opacity (0.5) is applied
            final opacityFinder = find.ancestor(
              of: find.byType(Checkbox),
              matching: find.byType(Opacity),
            );
            expect(
              opacityFinder,
              findsOneWidget,
              reason: 'Disabled checkbox should be wrapped in Opacity widget',
            );

            final opacityWidget = tester.widget<Opacity>(opacityFinder);
            expect(
              opacityWidget.opacity,
              0.5,
              reason: 'Disabled checkbox should have 0.5 opacity',
            );

            // Try to tap the checkbox
            await tester.tap(find.byType(Checkbox));
            await tester.pumpAndSettle();

            // Verify the value did not change
            expect(
              currentValue,
              initialValue,
              reason:
                  'Disabled checkbox should not respond to taps - value should remain $initialValue',
            );

            // If there's a label, try tapping the label/row
            if (hasLabel && label != null) {
              // Try tapping the label text
              await tester.tap(find.text(label));
              await tester.pumpAndSettle();

              // Verify the value still did not change
              expect(
                currentValue,
                initialValue,
                reason:
                    'Disabled checkbox with label should not respond to label taps - value should remain $initialValue',
              );

              // Verify InkWell has null onTap (disabled)
              final inkWellFinder = find.byType(InkWell);
              if (inkWellFinder.evaluate().isNotEmpty) {
                final inkWellWidget = tester.widget<InkWell>(inkWellFinder);
                expect(
                  inkWellWidget.onTap,
                  isNull,
                  reason: 'Disabled checkbox InkWell should have null onTap',
                );
              }
            }

            // Verify the Checkbox widget itself has null onChanged
            final checkboxWidget = tester.widget<Checkbox>(
              find.byType(Checkbox),
            );
            expect(
              checkboxWidget.onChanged,
              isNull,
              reason: 'Disabled checkbox should have null onChanged callback',
            );
          },
        );
      },
    );
  });
}
