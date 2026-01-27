import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';

void main() {
  group('AppDialog Edge Cases', () {
    testWidgets('handles null title gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    contentText: 'Content without title',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(
                    context: context,
                    title: 'Title without content',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(context: context, title: '', contentText: '');
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Dialog should still render
      expect(find.byType(AppDialog), findsOneWidget);
    });

    testWidgets('handles very long title', (WidgetTester tester) async {
      const longTitle =
          'This is a very long title that should be handled properly by the dialog component without causing overflow issues or layout problems';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: longTitle,
                    contentText: 'Content',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: longContent,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    primaryAction: AppDialogAction(
                      label: 'Disabled',
                      enabled: false,
                      onPressed: () {},
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Find the disabled button
      final disabledButton = find.widgetWithText(AppButton, 'Disabled');
      expect(disabledButton, findsOneWidget);

      // Verify button is disabled
      final button = tester.widget<AppButton>(disabledButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('handles multiple dialogs sequentially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await AppDialog.show(
                    context: context,
                    title: 'Dialog 1',
                    contentText: 'First dialog',
                  );

                  if (context.mounted) {
                    await AppDialog.show(
                      context: context,
                      title: 'Dialog 2',
                      contentText: 'Second dialog',
                    );
                  }
                },
                child: const Text('Open Dialogs'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialogs'));
      await tester.pumpAndSettle();

      // First dialog should be visible
      expect(find.text('Dialog 1'), findsOneWidget);

      // Close first dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // First dialog should be closed
      expect(find.text('Dialog 1'), findsNothing);
    });

    testWidgets('handles custom width and height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Custom Size',
                    contentText: 'Content',
                    width: 600,
                    height: 400,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Size'), findsOneWidget);
    });

    testWidgets('handles all animation types', (WidgetTester tester) async {
      final animations = [
        AppDialogAnimation.fade,
        AppDialogAnimation.scale,
        AppDialogAnimation.slideTop,
        AppDialogAnimation.slideBottom,
        AppDialogAnimation.slideLeft,
        AppDialogAnimation.slideRight,
        AppDialogAnimation.none,
      ];

      for (final animation in animations) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    AppDialog.show(
                      context: context,
                      title: 'Test',
                      contentText: 'Content',
                      animation: animation,
                    );
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Dialog'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));

        // Verify dialog appears
        expect(find.text('Test'), findsOneWidget);

        // Close dialog
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
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
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    barrierDismissible: false,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Try to tap outside dialog (on barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should still be visible
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles icon without container', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    icon: Icons.star,
                    showIconContainer: false,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('handles custom icon size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    icon: Icons.star,
                    iconSize: 48,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 48);
    });

    testWidgets('handles custom icon color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    icon: Icons.star,
                    iconColor: Colors.purple,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    showHeaderDivider: false,
                    showFooterDivider: false,
                    primaryAction: AppDialogAction(
                      label: 'OK',
                      onPressed: () {},
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog renders without dividers
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles custom background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    backgroundColor: Colors.amber,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    borderRadius: BorderRadius.circular(32),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    contentPadding: const EdgeInsets.all(32),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles non-centered dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    centerDialog: false,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    primaryAction: AppDialogAction(
                      label: 'Save',
                      icon: Icons.save,
                      onPressed: () {},
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('handles action button with custom colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    primaryAction: AppDialogAction(
                      label: 'Custom',
                      customBackgroundColor: Colors.purple,
                      customForegroundColor: Colors.white,
                      onPressed: () {},
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('handles progress without value (indeterminate)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    showProgress: true,
                    progressLabel: 'Loading...',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('handles custom loading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    isLoading: true,
                    loadingWidget: const Text('Custom Loading'),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Loading'), findsOneWidget);
    });

    testWidgets('handles hide title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Hidden Title',
                    showTitle: false,
                    contentText: 'Content',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Title should not be visible
      expect(find.text('Hidden Title'), findsNothing);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('handles hide subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Title',
                    subtitle: 'Hidden Subtitle',
                    showSubtitle: false,
                    contentText: 'Content',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Subtitle should not be visible
      expect(find.text('Hidden Subtitle'), findsNothing);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('handles max height constraint', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    maxHeight: 200,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    animationDuration: const Duration(milliseconds: 500),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // Dialog should be animating
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles custom barrier color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test',
                    contentText: 'Content',
                    barrierColor: Colors.red.withValues(alpha: 0.5),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
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
                    AppDialog.show(
                      context: context,
                      title: 'Test',
                      contentText: 'Content',
                      primaryAction: AppDialogAction(
                        label: 'Button',
                        size: size,
                        onPressed: () {},
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Button'), findsOneWidget);

        // Close dialog
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
                    AppDialog.show(
                      context: context,
                      title: 'Test',
                      contentText: 'Content',
                      primaryAction: AppDialogAction(
                        label: 'Button',
                        variant: variant,
                        onPressed: () {},
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Button'), findsOneWidget);

        // Close dialog
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
    });
  });
}
