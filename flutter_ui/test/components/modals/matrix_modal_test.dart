import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';

void main() {
  group('AppModal', () {
    testWidgets('renders with title and content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test Modal',
                    contentText: 'This is a test modal',
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      // Tap button to open modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Verify modal is displayed
      expect(find.text('Test Modal'), findsOneWidget);
      expect(find.text('This is a test modal'), findsOneWidget);
    });

    testWidgets('renders with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test Modal',
                    contentText: 'Content',
                    icon: Icons.info,
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

      // Verify icon is displayed
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('renders with primary and secondary actions', (
      WidgetTester tester,
    ) async {
      bool primaryPressed = false;
      bool secondaryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test Modal',
                    contentText: 'Content',
                    primaryAction: AppModalAction(
                      label: 'Primary',
                      onPressed: () {
                        primaryPressed = true;
                        Navigator.of(context).pop();
                      },
                    ),
                    secondaryAction: AppModalAction(
                      label: 'Secondary',
                      onPressed: () {
                        secondaryPressed = true;
                        Navigator.of(context).pop();
                      },
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

      // Verify buttons are displayed
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);

      // Tap secondary button
      await tester.tap(find.text('Secondary'));
      await tester.pumpAndSettle();

      expect(secondaryPressed, true);
      expect(primaryPressed, false);
    });

    testWidgets('can be dismissed with close button', (
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
                    title: 'Test Modal',
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

      // Verify modal is open
      expect(find.text('Test Modal'), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify modal is closed
      expect(find.text('Test Modal'), findsNothing);
    });

    testWidgets('renders different sizes correctly', (
      WidgetTester tester,
    ) async {
      final sizes = [
        AppModalSize.small,
        AppModalSize.medium,
        AppModalSize.large,
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
                      title: 'Test Modal',
                      contentText: 'Content',
                      size: size,
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

        // Verify modal is displayed
        expect(find.text('Test Modal'), findsOneWidget);

        // Close modal
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('renders different variants correctly', (
      WidgetTester tester,
    ) async {
      final variants = [
        AppModalVariant.default_,
        AppModalVariant.alert,
        AppModalVariant.confirmation,
        AppModalVariant.info,
        AppModalVariant.success,
        AppModalVariant.warning,
        AppModalVariant.error,
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
                      title: 'Test Modal',
                      contentText: 'Content',
                      variant: variant,
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

        // Verify modal is displayed
        expect(find.text('Test Modal'), findsOneWidget);

        // Close modal
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('alert helper method works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.alert(
                    context: context,
                    title: 'Alert',
                    contentText: 'This is an alert',
                  );
                },
                child: const Text('Open Alert'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Alert'));
      await tester.pumpAndSettle();

      expect(find.text('Alert'), findsOneWidget);
      expect(find.text('This is an alert'), findsOneWidget);
      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    });

    testWidgets('confirm helper method works', (WidgetTester tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await AppModal.confirm(
                    context: context,
                    title: 'Confirm',
                    contentText: 'Are you sure?',
                  );
                },
                child: const Text('Open Confirm'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Confirm'));
      await tester.pumpAndSettle();

      // Find the title "Confirm" in the modal header
      expect(find.text('Confirm'), findsAtLeastNWidgets(1));
      expect(find.text('Are you sure?'), findsOneWidget);

      // Tap confirm button (find by type AppButton and verify it's the primary action)
      final confirmButton = find.widgetWithText(AppButton, 'Confirm');
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(result, true);
    });

    testWidgets('info helper method works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.info(
                    context: context,
                    title: 'Info',
                    contentText: 'This is info',
                  );
                },
                child: const Text('Open Info'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Info'));
      await tester.pumpAndSettle();

      expect(find.text('Info'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });

    testWidgets('success helper method works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.success(
                    context: context,
                    title: 'Success',
                    contentText: 'Operation successful',
                  );
                },
                child: const Text('Open Success'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Success'));
      await tester.pumpAndSettle();

      expect(find.text('Success'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });

    testWidgets('warning helper method works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.warning(
                    context: context,
                    title: 'Warning',
                    contentText: 'This is a warning',
                  );
                },
                child: const Text('Open Warning'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Warning'));
      await tester.pumpAndSettle();

      expect(find.text('Warning'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('error helper method works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.error(
                    context: context,
                    title: 'Error',
                    contentText: 'An error occurred',
                  );
                },
                child: const Text('Open Error'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Error'));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('renders scrollable content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test Modal',
                    content: Column(
                      children: List.generate(
                        50,
                        (index) => ListTile(title: Text('Item $index')),
                      ),
                    ),
                    scrollable: true,
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

      // Verify scrollable content exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('renders custom header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    customHeader: const Text('Custom Header'),
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

      expect(find.text('Custom Header'), findsOneWidget);
    });

    testWidgets('renders custom footer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test Modal',
                    contentText: 'Content',
                    customFooter: const Text('Custom Footer'),
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

      expect(find.text('Custom Footer'), findsOneWidget);
    });

    testWidgets('can hide close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test Modal',
                    contentText: 'Content',
                    showCloseButton: false,
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

      // Verify close button is not present
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('renders with subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test Modal',
                    subtitle: 'This is a subtitle',
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

      expect(find.text('This is a subtitle'), findsOneWidget);
    });

    testWidgets('renders additional actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppModal.show(
                    context: context,
                    title: 'Test Modal',
                    contentText: 'Content',
                    additionalActions: [
                      AppModalAction(label: 'Action 1', onPressed: () {}),
                      AppModalAction(label: 'Action 2', onPressed: () {}),
                    ],
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

      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
    });
  });
}
