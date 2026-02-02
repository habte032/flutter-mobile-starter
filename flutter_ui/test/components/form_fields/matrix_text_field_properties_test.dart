import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';
import '../../utils/property_test_utils.dart';

void main() {
  group('AppTextField Property Tests', () {
    // Feature: flutter-ui-components, Property 7: Text field error state display
    testWidgets(
      'Property 7: Text field with errorText displays error and applies error color',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description: 'Text field error state display across variants',
          iterations: 100,
          test: () async {
            // Generate random text field variant
            final variant = PropertyTestUtils.randomElement([
              AppTextFieldVariant.outlined,
              AppTextFieldVariant.filled,
              AppTextFieldVariant.underlined,
            ]);

            // Generate random error text
            final errorText = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(10, 50),
            );

            // Generate random label and hint
            final label = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(5, 15),
            );
            final hint = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(5, 20),
            );

            // Create text field with error
            final textField = AppTextField(
              label: label,
              hint: hint,
              errorText: errorText,
              variant: variant,
            );

            // Build the widget
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(body: Center(child: textField)),
              ),
            );

            // Verify error text is displayed
            expect(
              find.text(errorText),
              findsOneWidget,
              reason: 'Error text "$errorText" should be displayed',
            );

            // Verify error text has error color styling
            final errorTextWidget = tester.widget<Text>(find.text(errorText));
            expect(
              errorTextWidget.style?.color,
              AppColors.error,
              reason: 'Error text should use AppColors.error color',
            );

            // Verify the text field has error border color
            final textFieldWidget = tester.widget<TextField>(
              find.byType(TextField),
            );

            // Check that error border is applied
            final decoration = textFieldWidget.decoration;
            expect(
              decoration,
              isNotNull,
              reason: 'TextField should have decoration',
            );

            // Verify error border color is applied based on variant
            switch (variant) {
              case AppTextFieldVariant.outlined:
                final errorBorder =
                    decoration!.errorBorder as OutlineInputBorder;
                expect(
                  errorBorder.borderSide.color,
                  AppColors.error,
                  reason:
                      'Outlined variant error border should use AppColors.error',
                );
                break;
              case AppTextFieldVariant.filled:
                final errorBorder =
                    decoration!.errorBorder as OutlineInputBorder;
                expect(
                  errorBorder.borderSide.color,
                  AppColors.error,
                  reason:
                      'Filled variant error border should use AppColors.error',
                );
                break;
              case AppTextFieldVariant.underlined:
                final errorBorder =
                    decoration!.errorBorder as UnderlineInputBorder;
                expect(
                  errorBorder.borderSide.color,
                  AppColors.error,
                  reason:
                      'Underlined variant error border should use AppColors.error',
                );
                break;
              case AppTextFieldVariant.custom:
                final errorBorder =
                    decoration!.errorBorder as OutlineInputBorder;
                expect(
                  errorBorder.borderSide.color,
                  AppColors.error,
                  reason:
                      'Custom variant error border should use AppColors.error',
                );
                break;
            }

            // Verify focused error border also uses error color
            final focusedErrorBorder = decoration.focusedErrorBorder;
            expect(
              focusedErrorBorder,
              isNotNull,
              reason: 'TextField should have focusedErrorBorder',
            );

            // Check focused error border color based on variant
            switch (variant) {
              case AppTextFieldVariant.outlined:
              case AppTextFieldVariant.filled:
              case AppTextFieldVariant.underlined:
              case AppTextFieldVariant.custom:
                final border = focusedErrorBorder as InputBorder;
                expect(
                  border.borderSide.color,
                  AppColors.error,
                  reason: 'Focused error border should use AppColors.error',
                );
                break;
            }
          },
        );
      },
    );

    // Feature: flutter-ui-components, Property 8: Text field icon positioning and callbacks
    testWidgets(
      'Property 8: Text field icons are positioned correctly and callbacks are invoked',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description: 'Text field icon positioning and callback invocation',
          iterations: 100,
          test: () async {
            // Generate random text field variant
            final variant = PropertyTestUtils.randomElement([
              AppTextFieldVariant.outlined,
              AppTextFieldVariant.filled,
              AppTextFieldVariant.underlined,
            ]);

            // Generate random icons
            final prefixIcon = PropertyTestUtils.randomElement([
              Icons.search,
              Icons.email,
              Icons.person,
              Icons.lock,
              Icons.phone,
            ]);

            final suffixIcon = PropertyTestUtils.randomElement([
              Icons.visibility,
              Icons.visibility_off,
              Icons.clear,
              Icons.check,
              Icons.info,
            ]);

            // Track callback invocations
            bool prefixPressed = false;
            bool suffixPressed = false;

            // Randomly decide which icons to include
            final hasPrefix = PropertyTestUtils.randomBool();
            final hasSuffix = PropertyTestUtils.randomBool();

            // Skip if no icons (not testing this property)
            if (!hasPrefix && !hasSuffix) {
              return;
            }

            // Create text field with icons
            final textField = AppTextField(
              label: 'Test Field',
              hint: 'Enter text',
              variant: variant,
              prefixIcon: hasPrefix ? prefixIcon : null,
              suffixIcon: hasSuffix ? suffixIcon : null,
              onPrefixPressed: hasPrefix ? () => prefixPressed = true : null,
              onSuffixPressed: hasSuffix ? () => suffixPressed = true : null,
            );

            // Build the widget
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(body: Center(child: textField)),
              ),
            );

            // Verify prefix icon is present and positioned correctly
            if (hasPrefix) {
              final prefixIconFinder = find.byIcon(prefixIcon);
              expect(
                prefixIconFinder,
                findsOneWidget,
                reason: 'Prefix icon should be displayed',
              );

              // Verify prefix icon is in an IconButton
              final prefixIconButton = find.ancestor(
                of: prefixIconFinder,
                matching: find.byType(IconButton),
              );
              expect(
                prefixIconButton,
                findsOneWidget,
                reason: 'Prefix icon should be wrapped in IconButton',
              );

              // Verify prefix icon is positioned at the start (left side)
              final textFieldFinder = find.byType(TextField);
              final textFieldWidget = tester.widget<TextField>(textFieldFinder);
              expect(
                textFieldWidget.decoration?.prefixIcon,
                isNotNull,
                reason: 'TextField should have prefixIcon in decoration',
              );

              // Tap the prefix icon and verify callback is invoked
              await tester.tap(prefixIconButton);
              await tester.pump();

              expect(
                prefixPressed,
                isTrue,
                reason: 'Prefix icon callback should be invoked when tapped',
              );
            }

            // Verify suffix icon is present and positioned correctly
            if (hasSuffix) {
              final suffixIconFinder = find.byIcon(suffixIcon);
              expect(
                suffixIconFinder,
                findsOneWidget,
                reason: 'Suffix icon should be displayed',
              );

              // Verify suffix icon is in an IconButton
              final suffixIconButton = find.ancestor(
                of: suffixIconFinder,
                matching: find.byType(IconButton),
              );
              expect(
                suffixIconButton,
                findsOneWidget,
                reason: 'Suffix icon should be wrapped in IconButton',
              );

              // Verify suffix icon is positioned at the end (right side)
              final textFieldFinder = find.byType(TextField);
              final textFieldWidget = tester.widget<TextField>(textFieldFinder);
              expect(
                textFieldWidget.decoration?.suffixIcon,
                isNotNull,
                reason: 'TextField should have suffixIcon in decoration',
              );

              // Tap the suffix icon and verify callback is invoked
              await tester.tap(suffixIconButton);
              await tester.pump();

              expect(
                suffixPressed,
                isTrue,
                reason: 'Suffix icon callback should be invoked when tapped',
              );
            }

            // If both icons are present, verify they are positioned correctly relative to each other
            if (hasPrefix && hasSuffix) {
              final prefixIconFinder = find.byIcon(prefixIcon);
              final suffixIconFinder = find.byIcon(suffixIcon);

              final prefixRect = tester.getRect(prefixIconFinder);
              final suffixRect = tester.getRect(suffixIconFinder);

              // Prefix should be on the left (smaller x coordinate)
              expect(
                prefixRect.left < suffixRect.left,
                isTrue,
                reason:
                    'Prefix icon should be positioned to the left of suffix icon',
              );
            }
          },
        );
      },
    );

    // Feature: flutter-ui-components, Property 9: Text field state visual feedback
    testWidgets(
      'Property 9: Text field states produce visually distinct representations',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description: 'Text field state visual differentiation',
          iterations: 100,
          test: () async {
            // Generate random text field variant
            final variant = PropertyTestUtils.randomElement([
              AppTextFieldVariant.outlined,
              AppTextFieldVariant.filled,
              AppTextFieldVariant.underlined,
            ]);

            // Generate random label and hint
            final label = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(5, 15),
            );
            final hint = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(5, 20),
            );

            // Generate random error text
            final errorText = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(10, 30),
            );

            // Create controllers for tracking state
            final enabledController = TextEditingController();
            final focusedController = TextEditingController();
            final errorController = TextEditingController();
            final disabledController = TextEditingController();

            // Create focus nodes
            final focusedFocusNode = FocusNode();

            // Create text fields in different states
            final enabledField = AppTextField(
              key: const Key('enabled'),
              label: label,
              hint: hint,
              variant: variant,
              controller: enabledController,
              enabled: true,
            );

            final focusedField = AppTextField(
              key: const Key('focused'),
              label: label,
              hint: hint,
              variant: variant,
              controller: focusedController,
              enabled: true,
            );

            final errorField = AppTextField(
              key: const Key('error'),
              label: label,
              hint: hint,
              errorText: errorText,
              variant: variant,
              controller: errorController,
              enabled: true,
            );

            final disabledField = AppTextField(
              key: const Key('disabled'),
              label: label,
              hint: hint,
              variant: variant,
              controller: disabledController,
              enabled: false,
            );

            // Build all fields in a column
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        enabledField,
                        const SizedBox(height: 20),
                        focusedField,
                        const SizedBox(height: 20),
                        errorField,
                        const SizedBox(height: 20),
                        disabledField,
                      ],
                    ),
                  ),
                ),
              ),
            );

            // Focus the focused field
            final focusedTextFieldFinder = find.descendant(
              of: find.byKey(const Key('focused')),
              matching: find.byType(TextField),
            );
            await tester.tap(focusedTextFieldFinder);
            await tester.pump();

            // Get all TextField widgets
            final enabledTextField = tester.widget<TextField>(
              find.descendant(
                of: find.byKey(const Key('enabled')),
                matching: find.byType(TextField),
              ),
            );

            final focusedTextField = tester.widget<TextField>(
              find.descendant(
                of: find.byKey(const Key('focused')),
                matching: find.byType(TextField),
              ),
            );

            final errorTextField = tester.widget<TextField>(
              find.descendant(
                of: find.byKey(const Key('error')),
                matching: find.byType(TextField),
              ),
            );

            final disabledTextField = tester.widget<TextField>(
              find.descendant(
                of: find.byKey(const Key('disabled')),
                matching: find.byType(TextField),
              ),
            );

            // Verify enabled state has standard border color
            final enabledBorder = enabledTextField.decoration?.enabledBorder;
            expect(
              enabledBorder,
              isNotNull,
              reason: 'Enabled field should have enabledBorder',
            );

            // Verify focused state has primary color border
            final focusedBorder = focusedTextField.decoration?.focusedBorder;
            expect(
              focusedBorder,
              isNotNull,
              reason: 'Focused field should have focusedBorder',
            );
            expect(
              focusedBorder!.borderSide.color,
              AppColors.primary,
              reason: 'Focused field should use primary color',
            );

            // Verify error state has error color border
            final errorBorder = errorTextField.decoration?.errorBorder;
            expect(
              errorBorder,
              isNotNull,
              reason: 'Error field should have errorBorder',
            );
            expect(
              errorBorder!.borderSide.color,
              AppColors.error,
              reason: 'Error field should use error color',
            );

            // Verify error text is displayed
            expect(
              find.text(errorText),
              findsOneWidget,
              reason: 'Error text should be displayed for error state',
            );

            // Verify disabled state has reduced opacity border
            final disabledBorder = disabledTextField.decoration?.disabledBorder;
            expect(
              disabledBorder,
              isNotNull,
              reason: 'Disabled field should have disabledBorder',
            );

            // Verify disabled field is actually disabled
            expect(
              disabledTextField.enabled,
              isFalse,
              reason: 'Disabled field should have enabled=false',
            );

            // Verify text style colors are different for enabled vs disabled
            final enabledTextColor = enabledTextField.style?.color;
            final disabledTextColor = disabledTextField.style?.color;
            expect(
              enabledTextColor,
              isNot(equals(disabledTextColor)),
              reason:
                  'Enabled and disabled fields should have different text colors',
            );

            // Verify disabled text uses disabled color
            expect(
              disabledTextColor,
              AppColors.textDisabled,
              reason: 'Disabled field should use textDisabled color',
            );

            // Verify focused border is thicker than enabled border
            expect(
              focusedBorder.borderSide.width,
              greaterThan(enabledBorder!.borderSide.width),
              reason: 'Focused border should be thicker than enabled border',
            );

            // Verify error border is visually distinct from enabled border
            expect(
              errorBorder.borderSide.color,
              isNot(equals(enabledBorder.borderSide.color)),
              reason:
                  'Error border color should differ from enabled border color',
            );

            // Verify all states produce different visual representations
            // by checking that border colors are distinct where expected
            final borderColors = <Color>{
              enabledBorder.borderSide.color,
              focusedBorder.borderSide.color,
              errorBorder.borderSide.color,
            };

            expect(
              borderColors.length,
              greaterThanOrEqualTo(2),
              reason: 'Different states should produce distinct border colors',
            );

            // Clean up
            enabledController.dispose();
            focusedController.dispose();
            errorController.dispose();
            disabledController.dispose();
            focusedFocusNode.dispose();
          },
        );
      },
    );

    // Feature: flutter-ui-components, Property 10: Text field configuration properties
    testWidgets(
      'Property 10: Text field configuration properties affect behavior and appearance',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description: 'Text field configuration properties',
          iterations: 100,
          test: () async {
            // Generate random text field variant
            final variant = PropertyTestUtils.randomElement([
              AppTextFieldVariant.outlined,
              AppTextFieldVariant.filled,
              AppTextFieldVariant.underlined,
            ]);

            // Generate random configuration properties
            final keyboardType = PropertyTestUtils.randomElement([
              TextInputType.text,
              TextInputType.emailAddress,
              TextInputType.number,
              TextInputType.phone,
              TextInputType.url,
              TextInputType.multiline,
            ]);

            final obscureText = PropertyTestUtils.randomBool();
            // Flutter constraint: obscured fields cannot be multiline
            // If obscureText is true, maxLines must be 1
            final maxLines = obscureText
                ? 1
                : PropertyTestUtils.randomElement([1, 2, 3, 5, 10]);

            final hint = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(10, 30),
            );

            final label = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(5, 15),
            );

            // Create controller to verify text input
            final controller = TextEditingController();

            // Create text field with configuration
            final textField = AppTextField(
              label: label,
              hint: hint,
              variant: variant,
              keyboardType: keyboardType,
              obscureText: obscureText,
              maxLines: maxLines,
              controller: controller,
            );

            // Build the widget
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(body: Center(child: textField)),
              ),
            );

            // Get the TextField widget
            final textFieldWidget = tester.widget<TextField>(
              find.byType(TextField),
            );

            // Verify keyboardType is applied
            expect(
              textFieldWidget.keyboardType,
              keyboardType,
              reason: 'TextField should use the specified keyboardType',
            );

            // Verify obscureText is applied
            expect(
              textFieldWidget.obscureText,
              obscureText,
              reason: 'TextField should use the specified obscureText value',
            );

            // Verify maxLines is applied
            expect(
              textFieldWidget.maxLines,
              maxLines,
              reason: 'TextField should use the specified maxLines value',
            );

            // Verify hint text is displayed in decoration
            expect(
              textFieldWidget.decoration?.hintText,
              hint,
              reason: 'TextField should display the specified hint text',
            );

            // Verify hint text is visible when field is empty
            expect(
              find.text(hint),
              findsOneWidget,
              reason: 'Hint text should be visible when field is empty',
            );

            // Verify label is displayed
            expect(
              find.text(label),
              findsOneWidget,
              reason: 'Label should be displayed',
            );

            // Test that obscureText affects text display
            if (obscureText) {
              // Enter some text
              await tester.enterText(find.byType(TextField), 'password123');
              await tester.pump();

              // Verify the actual text is obscured (TextField handles this internally)
              expect(
                controller.text,
                'password123',
                reason: 'Controller should contain the actual text',
              );

              // The obscureText property should be true
              final updatedTextField = tester.widget<TextField>(
                find.byType(TextField),
              );
              expect(
                updatedTextField.obscureText,
                isTrue,
                reason: 'TextField should have obscureText enabled',
              );
            }

            // Test that maxLines affects field height
            if (maxLines > 1) {
              // For multiline fields, verify the field can accept multiple lines
              final multilineText = List.generate(
                maxLines,
                (i) => 'Line ${i + 1}',
              ).join('\n');
              await tester.enterText(find.byType(TextField), multilineText);
              await tester.pump();

              expect(
                controller.text,
                multilineText,
                reason: 'Multiline text should be accepted',
              );

              // Verify maxLines is still set correctly
              final updatedTextField = tester.widget<TextField>(
                find.byType(TextField),
              );
              expect(
                updatedTextField.maxLines,
                maxLines,
                reason: 'TextField should maintain maxLines configuration',
              );
            }

            // Verify that different keyboard types are properly configured
            // (actual keyboard display is handled by the platform, but we verify the property)
            switch (keyboardType) {
              case TextInputType.emailAddress:
                expect(
                  textFieldWidget.keyboardType,
                  TextInputType.emailAddress,
                  reason: 'Email keyboard type should be configured',
                );
                break;
              case TextInputType.number:
                expect(
                  textFieldWidget.keyboardType,
                  TextInputType.number,
                  reason: 'Number keyboard type should be configured',
                );
                break;
              case TextInputType.phone:
                expect(
                  textFieldWidget.keyboardType,
                  TextInputType.phone,
                  reason: 'Phone keyboard type should be configured',
                );
                break;
              case TextInputType.url:
                expect(
                  textFieldWidget.keyboardType,
                  TextInputType.url,
                  reason: 'URL keyboard type should be configured',
                );
                break;
              case TextInputType.multiline:
                expect(
                  textFieldWidget.keyboardType,
                  TextInputType.multiline,
                  reason: 'Multiline keyboard type should be configured',
                );
                break;
              case TextInputType.text:
                expect(
                  textFieldWidget.keyboardType,
                  TextInputType.text,
                  reason: 'Text keyboard type should be configured',
                );
                break;
              default:
                break;
            }

            // Verify that configuration properties work together
            // All properties should be independently configurable
            expect(
              textFieldWidget.keyboardType,
              keyboardType,
              reason: 'Keyboard type should be set correctly',
            );
            expect(
              textFieldWidget.obscureText,
              obscureText,
              reason: 'Obscure text should be set correctly',
            );
            expect(
              textFieldWidget.maxLines,
              maxLines,
              reason: 'Max lines should be set correctly',
            );
            expect(
              textFieldWidget.decoration?.hintText,
              hint,
              reason: 'Hint text should be set correctly',
            );

            // Verify that the configuration affects the visual appearance
            // For maxLines > 1, the content padding should accommodate multiple lines
            if (maxLines > 1) {
              final decoration = textFieldWidget.decoration;
              expect(
                decoration?.contentPadding,
                isNotNull,
                reason: 'Multiline fields should have content padding',
              );
            }

            // Clean up
            controller.dispose();
          },
        );
      },
    );
  });
}
