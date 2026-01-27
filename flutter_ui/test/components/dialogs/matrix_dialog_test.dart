import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';

void main() {
  group('AppDialog', () {
    testWidgets('renders with title and content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    contentText: 'This is a test dialog',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap button to open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('This is a test dialog'), findsOneWidget);
    });

    testWidgets('renders with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    contentText: 'Content',
                    icon: Icons.info,
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
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    contentText: 'Content',
                    primaryAction: AppDialogAction(
                      label: 'Primary',
                      onPressed: () {
                        primaryPressed = true;
                        Navigator.of(context).pop();
                      },
                    ),
                    secondaryAction: AppDialogAction(
                      label: 'Secondary',
                      onPressed: () {
                        secondaryPressed = true;
                        Navigator.of(context).pop();
                      },
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
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
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

      // Verify dialog is open
      expect(find.text('Test Dialog'), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Test Dialog'), findsNothing);
    });

    testWidgets('renders different sizes correctly', (
      WidgetTester tester,
    ) async {
      final sizes = [
        AppDialogSize.small,
        AppDialogSize.medium,
        AppDialogSize.large,
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
                      title: 'Test Dialog',
                      contentText: 'Content',
                      size: size,
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

        // Verify dialog is displayed
        expect(find.text('Test Dialog'), findsOneWidget);

        // Close dialog
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('renders different variants correctly', (
      WidgetTester tester,
    ) async {
      final variants = [
        AppDialogVariant.default_,
        AppDialogVariant.alert,
        AppDialogVariant.confirmation,
        AppDialogVariant.info,
        AppDialogVariant.success,
        AppDialogVariant.warning,
        AppDialogVariant.error,
        AppDialogVariant.destructive,
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
                      title: 'Test Dialog',
                      contentText: 'Content',
                      variant: variant,
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

        // Verify dialog is displayed
        expect(find.text('Test Dialog'), findsOneWidget);

        // Close dialog
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
                  AppDialog.alert(
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
                  result = await AppDialog.confirm(
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

      expect(find.text('Confirm'), findsAtLeastNWidgets(1));
      expect(find.text('Are you sure?'), findsOneWidget);

      // Tap confirm button
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
                  AppDialog.info(
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
                  AppDialog.success(
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
                  AppDialog.warning(
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
                  AppDialog.error(
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

    testWidgets('destructive helper method works', (WidgetTester tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await AppDialog.destructive(
                    context: context,
                    title: 'Delete Item',
                    contentText: 'Are you sure you want to delete?',
                  );
                },
                child: const Text('Open Destructive'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Destructive'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Item'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

      // Tap cancel button
      final cancelButton = find.widgetWithText(AppButton, 'Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(result, false);
    });

    testWidgets('renders scrollable content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    content: ListView(
                      shrinkWrap: true,
                      children: List.generate(
                        20,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Item $index'),
                        ),
                      ),
                    ),
                    scrollable: false, // Content is already scrollable
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

      // Verify content exists
      expect(find.text('Item 0'), findsOneWidget);
    });

    testWidgets('renders custom header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    customHeader: const Text('Custom Header'),
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

      expect(find.text('Custom Header'), findsOneWidget);
    });

    testWidgets('renders custom footer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    contentText: 'Content',
                    customFooter: const Text('Custom Footer'),
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

      expect(find.text('Custom Footer'), findsOneWidget);
    });

    testWidgets('can hide close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    contentText: 'Content',
                    showCloseButton: false,
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
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    subtitle: 'This is a subtitle',
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

      expect(find.text('This is a subtitle'), findsOneWidget);
    });

    testWidgets('renders additional actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    contentText: 'Content',
                    additionalActions: [
                      AppDialogAction(label: 'Action 1', onPressed: () {}),
                      AppDialogAction(label: 'Action 2', onPressed: () {}),
                    ],
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

      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
    });

    testWidgets('renders with rich content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    richContent: [
                      const TextSpan(text: 'This is '),
                      TextSpan(
                        text: 'bold',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' text.'),
                    ],
                    scrollable: false,
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
      await tester.pump(const Duration(milliseconds: 100));

      // Verify dialog is displayed
      expect(find.text('Test Dialog'), findsOneWidget);

      // Verify rich text widget exists (RichText creates separate text spans)
      final richTextWidgets = find.byType(RichText);
      expect(richTextWidgets, findsAtLeastNWidgets(1));
    });

    testWidgets('renders loading indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    contentText: 'Loading...',
                    isLoading: true,
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
      await tester.pump(const Duration(milliseconds: 100));

      // Verify loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders progress indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppDialog.show(
                    context: context,
                    title: 'Test Dialog',
                    showProgress: true,
                    progressValue: 0.5,
                    progressLabel: 'Uploading...',
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

      // Verify progress indicator is displayed
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Uploading...'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('renders with custom title widget', (
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
                    customTitle: const Text('Custom Title'),
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

      expect(find.text('Custom Title'), findsOneWidget);
    });
  });
}
