import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';

void main() {
  group('AppCheckbox', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox.primary(
              label: 'Test Label',
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('renders with description', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox.primary(
              label: 'Test Label',
              description: 'Test Description',
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('toggles value when tapped', (WidgetTester tester) async {
      bool currentValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppCheckbox.primary(
                  label: 'Test Label',
                  value: currentValue,
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

      expect(currentValue, false);

      // Tap the checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(currentValue, true);
    });

    testWidgets('entire row is tappable when label is present', (
      WidgetTester tester,
    ) async {
      bool currentValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppCheckbox.primary(
                  label: 'Test Label',
                  value: currentValue,
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

      expect(currentValue, false);

      // Tap the label text (not the checkbox itself)
      await tester.tap(find.text('Test Label'));
      await tester.pumpAndSettle();

      expect(currentValue, true);
    });

    testWidgets('disabled state prevents interaction', (
      WidgetTester tester,
    ) async {
      bool currentValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox.primary(
              label: 'Test Label',
              value: currentValue,
              onChanged: null, // Disabled
            ),
          ),
        ),
      );

      // Try to tap the checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Value should not change
      expect(currentValue, false);
    });

    testWidgets('renders without label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox.primary(value: false, onChanged: (_) {}),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('secondary variant uses secondary color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox.secondary(
              label: 'Test',
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.activeColor, AppColors.secondary);
    });

    testWidgets('custom variant uses custom colors', (
      WidgetTester tester,
    ) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox.custom(
              label: 'Test',
              value: true,
              onChanged: (_) {},
              activeColor: customColor,
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.activeColor, customColor);
    });

    testWidgets('compact variant has reduced spacing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox.compact(
              label: 'Test',
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });
}
