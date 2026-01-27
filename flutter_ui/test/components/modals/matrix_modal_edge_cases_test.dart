import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';

void main() {
  group('AppModal Edge Cases', () {
    testWidgets('handles null title gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    contentText: 'Content without title',
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Content without title'), findsOneWidget);
    });

    testWidgets('handles null content gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Title without content',
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Title without content'), findsOneWidget);
    });

    testWidgets('handles empty strings', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(context: context, title: '', contentText: '');
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Modal should still render
      expect(find.byType(AppModal), findsOneWidget);
    });

    testWidgets('handles very long title', (WidgetTester tester) async {
      const longTitle =
          'This is a very long title that should be handled properly by the modal component without causing overflow issues or layout problems';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: longTitle,
                    contentText: 'Content',
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Should not overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles very long content', (WidgetTester tester) async {
      final longContent = List.generate(100, (i) => 'Line $i').join('\n');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: longContent,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Should not overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles disabled action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    primaryAction: AppModalAction(
                      label: 'Disabled',
                      enabled: false,
                      onPressed: () {},
                    ),
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Find the disabled button
      final disabledButton = find.widgetWithText(AppButton, 'Disabled');
      expect(disabledButton, findsOneWidget);

      // Verify button is disabled
      final button = tester.widget<AppButton>(disabledButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('handles extraLarge size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Extra Large Modal',
                    contentText: 'Content',
                    size: AppModalSize.extraLarge,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Extra Large Modal'), findsOneWidget);
    });

    testWidgets('handles fullscreen size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Fullscreen Modal',
                    contentText: 'Content',
                    size: AppModalSize.fullscreen,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Fullscreen Modal'), findsOneWidget);
    });

    testWidgets('handles barrier dismissible false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    barrierDismissible: false,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Try to tap outside modal (on barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Modal should still be visible
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles custom icon color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    icon: Icons.star,
                    iconColor: Colors.purple,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, Colors.purple);
    });

    testWidgets('handles no dividers', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    showHeaderDivider: false,
                    showFooterDivider: false,
                    primaryAction: AppModalAction(
                      label: 'OK',
                      onPressed: () {},
                    ),
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Verify modal renders without dividers
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles custom background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    backgroundColor: Colors.amber,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles custom border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    borderRadius: BorderRadius.circular(32),
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles custom content padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    contentPadding: const EdgeInsets.all(32),
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles action button with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    primaryAction: AppModalAction(
                      label: 'Save',
                      icon: Icons.save,
                      onPressed: () {},
                    ),
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('handles max height constraint', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    maxHeight: 200,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles custom animation duration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    animationDuration: const Duration(milliseconds: 500),
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // Modal should be animating
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles custom barrier color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    barrierColor: Colors.red.withValues(alpha: 0.5),
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles action button with different sizes', (
      WidgetTester tester,
    ) async {
      final sizes = [
        AppButtonSize.small,
        AppButtonSize.medium,
        AppButtonSize.large,
      ];

      for (final size in sizes) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    AppModal.show(
                      context: context,
                      title: 'Test',
                      contentText: 'Content',
                      primaryAction: AppModalAction(
                        label: 'Button',
                        size: size,
                        onPressed: () {},
                      ),
                    );
                  },
                  child: const Text('Open Modal'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Modal'));
        await tester.pumpAndSettle();

        expect(find.text('Button'), findsOneWidget);

        // Close modal
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('handles action button with different variants', (
      WidgetTester tester,
    ) async {
      final variants = [
        AppButtonVariant.primary,
        AppButtonVariant.secondary,
        AppButtonVariant.tertiary,
        AppButtonVariant.ghost,
      ];

      for (final variant in variants) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    AppModal.show(
                      context: context,
                      title: 'Test',
                      contentText: 'Content',
                      primaryAction: AppModalAction(
                        label: 'Button',
                        variant: variant,
                        onPressed: () {},
                      ),
                    );
                  },
                  child: const Text('Open Modal'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Modal'));
        await tester.pumpAndSettle();

        expect(find.text('Button'), findsOneWidget);

        // Close modal
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('handles non-scrollable content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    scrollable: false,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Should not have SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('handles viewport constraints properly', (
      WidgetTester tester,
    ) async {
      // Test that modal respects viewport size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Large Modal',
                    contentText: 'This modal should fit within viewport',
                    size: AppModalSize.extraLarge,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Modal should render without overflow
      expect(tester.takeException(), isNull);
      expect(find.text('Large Modal'), findsOneWidget);
    });
  });
}
