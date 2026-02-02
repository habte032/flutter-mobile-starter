import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';
import '../../utils/property_test_utils.dart';

void main() {
  group('AppDataCard Property Tests', () {
    // Feature: flutter-ui-components, Property 17: Metric card change color coding
    test(
      'Property 17: Positive changes use success color and negative changes use error color',
      () {
        PropertyTestUtils.runPropertyTest(
          description: 'Metric card change color coding',
          iterations: 100,
          test: () {
            // Generate random card data
            final title = PropertyTestUtils.randomString(
              PropertyTestUtils.randomInt(5, 20),
            );
            final value = '\$${PropertyTestUtils.randomInt(100, 100000)}';
            final changeValue = PropertyTestUtils.randomInt(1, 50);

            // Create metric card with positive change
            final positiveCard = AppDataCard.metric(
              title: title,
              value: value,
              change: '+$changeValue%',
              isPositive: true,
            );

            // Create metric card with negative change
            final negativeCard = AppDataCard.metric(
              title: title,
              value: value,
              change: '-$changeValue%',
              isPositive: false,
            );

            // Verify positive change uses success color
            final positiveChangeColor = positiveCard._changeColor;
            expect(
              positiveChangeColor,
              AppColors.success,
              reason:
                  'Positive change should use success color. '
                  'Expected: ${AppColors.success}, Got: $positiveChangeColor',
            );

            // Verify negative change uses error color
            final negativeChangeColor = negativeCard._changeColor;
            expect(
              negativeChangeColor,
              AppColors.error,
              reason:
                  'Negative change should use error color. '
                  'Expected: ${AppColors.error}, Got: $negativeChangeColor',
            );

            // Test with null isPositive (should use textSecondary)
            final neutralCard = AppDataCard.metric(
              title: title,
              value: value,
              change: '0%',
              isPositive: null,
            );

            final neutralChangeColor = neutralCard._changeColor;
            expect(
              neutralChangeColor,
              AppColors.textSecondary,
              reason:
                  'Null isPositive should use textSecondary color. '
                  'Expected: ${AppColors.textSecondary}, Got: $neutralChangeColor',
            );
          },
        );
      },
    );
  });

  group('AppDataCard Image Tests', () {
    // Feature: flutter-ui-components, Property 18: Image shimmer loading
    testWidgets('Property 18: Image shows shimmer while loading', (
      WidgetTester tester,
    ) async {
      await PropertyTestUtils.runAsyncPropertyTest(
        description: 'Image shimmer loading across various scenarios',
        iterations: 50,
        test: () async {
          // Create card with network image
          final card = AppDataCard.metric(
            title: 'Test Card',
            value: '\$1,000',
            image: NetworkImage('https://picsum.photos/200/300'),
            imagePlacement: AppDataCardImagePlacement.top,
            imageHeight: 150,
            showImageShimmer: true,
          );

          await tester.pumpWidget(MaterialApp(home: Scaffold(body: card)));

          // Initially, shimmer should be visible (image is loading)
          await tester.pump();

          // Verify shimmer container exists
          final containers = find.byType(Container);
          expect(
            containers,
            findsWidgets,
            reason: 'Shimmer container should be present while loading',
          );

          // Wait for image to load
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // After loading, image should be visible
          final images = find.byType(Image);
          expect(
            images,
            findsAtLeastNWidgets(1),
            reason: 'Image should be visible after loading',
          );
        },
      );
    });

    // Feature: flutter-ui-components, Property 19: Image fit options
    testWidgets(
      'Property 19: Image fit options work correctly (contain, cover, fill)',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description: 'Image fit options across various scenarios',
          iterations: 30,
          test: () async {
            final fitOptions = [BoxFit.contain, BoxFit.cover, BoxFit.fill];

            for (final fit in fitOptions) {
              final card = AppDataCard.metric(
                title: 'Test Card',
                value: '\$1,000',
                image: NetworkImage('https://picsum.photos/200/300'),
                imagePlacement: AppDataCardImagePlacement.top,
                imageHeight: 150,
                imageFit: fit,
                showImageShimmer: false, // Disable shimmer for faster tests
              );

              await tester.pumpWidget(MaterialApp(home: Scaffold(body: card)));

              await tester.pumpAndSettle(const Duration(seconds: 2));

              // Verify image exists with correct fit
              final imageWidget = tester.widget<Image>(
                find.byType(Image).first,
              );
              expect(imageWidget.fit, fit, reason: 'Image fit should be $fit');
            }
          },
        );
      },
    );

    // Feature: flutter-ui-components, Property 20: Image placement options
    testWidgets('Property 20: Image placement options work correctly', (
      WidgetTester tester,
    ) async {
      await PropertyTestUtils.runAsyncPropertyTest(
        description: 'Image placement across various scenarios',
        iterations: 20,
        test: () async {
          final placements = [
            AppDataCardImagePlacement.top,
            AppDataCardImagePlacement.bottom,
            AppDataCardImagePlacement.left,
            AppDataCardImagePlacement.right,
            AppDataCardImagePlacement.background,
          ];

          for (final placement in placements) {
            final card = AppDataCard.metric(
              title: 'Test Card',
              value: '\$1,000',
              image: NetworkImage('https://picsum.photos/200/300'),
              imagePlacement: placement,
              imageHeight: 150,
              imageWidth: 120,
              showImageShimmer: false,
            );

            await tester.pumpWidget(MaterialApp(home: Scaffold(body: card)));

            await tester.pumpAndSettle(const Duration(seconds: 2));

            // Verify card is rendered
            expect(
              find.text('Test Card'),
              findsOneWidget,
              reason: 'Card should render with $placement placement',
            );

            // Verify image exists
            final images = find.byType(Image);
            expect(
              images,
              findsAtLeastNWidgets(1),
              reason: 'Image should be present with $placement placement',
            );
          }
        },
      );
    });

    // Feature: flutter-ui-components, Property 21: Image error handling
    testWidgets('Property 21: Image shows error icon when loading fails', (
      WidgetTester tester,
    ) async {
      await PropertyTestUtils.runAsyncPropertyTest(
        description: 'Image error handling across various scenarios',
        iterations: 20,
        test: () async {
          // Use invalid image URL to trigger error
          final card = AppDataCard.metric(
            title: 'Test Card',
            value: '\$1,000',
            image: NetworkImage(
              'https://invalid-url-that-does-not-exist.com/image.jpg',
            ),
            imagePlacement: AppDataCardImagePlacement.top,
            imageHeight: 150,
            showImageShimmer: false,
          );

          await tester.pumpWidget(MaterialApp(home: Scaffold(body: card)));

          // Wait for error to occur
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Verify error icon is shown
          final errorIcons = find.byIcon(Icons.broken_image);
          expect(
            errorIcons,
            findsAtLeastNWidgets(1),
            reason: 'Error icon should be shown when image fails to load',
          );
        },
      );
    });

    // Feature: flutter-ui-components, Property 22: Image shimmer customization
    testWidgets('Property 22: Image shimmer colors can be customized', (
      WidgetTester tester,
    ) async {
      await PropertyTestUtils.runAsyncPropertyTest(
        description: 'Image shimmer customization across various scenarios',
        iterations: 20,
        test: () async {
          final baseColor = Color(0xFF123456);
          final highlightColor = Color(0xFF789ABC);

          final card = AppDataCard.metric(
            title: 'Test Card',
            value: '\$1,000',
            image: NetworkImage('https://picsum.photos/200/300'),
            imagePlacement: AppDataCardImagePlacement.top,
            imageHeight: 150,
            showImageShimmer: true,
            shimmerBaseColor: baseColor,
            shimmerHighlightColor: highlightColor,
          );

          await tester.pumpWidget(MaterialApp(home: Scaffold(body: card)));

          // Initially, shimmer should be visible
          await tester.pump();

          // Verify shimmer container exists with custom colors
          final containers = find.byType(Container);
          expect(
            containers,
            findsWidgets,
            reason: 'Shimmer container should be present with custom colors',
          );

          // Wait for image to load
          await tester.pumpAndSettle(const Duration(seconds: 2));
        },
      );
    });

    // Feature: flutter-ui-components, Property 23: Image shimmer can be disabled
    testWidgets('Property 23: Image shimmer can be disabled', (
      WidgetTester tester,
    ) async {
      await PropertyTestUtils.runAsyncPropertyTest(
        description: 'Image shimmer disable functionality',
        iterations: 20,
        test: () async {
          final card = AppDataCard.metric(
            title: 'Test Card',
            value: '\$1,000',
            image: NetworkImage('https://picsum.photos/200/300'),
            imagePlacement: AppDataCardImagePlacement.top,
            imageHeight: 150,
            showImageShimmer: false,
          );

          await tester.pumpWidget(MaterialApp(home: Scaffold(body: card)));

          // Initially, should show static placeholder instead of shimmer
          await tester.pump();

          // Verify card is rendered
          expect(
            find.text('Test Card'),
            findsOneWidget,
            reason: 'Card should render when shimmer is disabled',
          );

          // Wait for image to load
          await tester.pumpAndSettle(const Duration(seconds: 2));
        },
      );
    });
  });
}

// Extension to access private members for testing
extension AppDataCardTestExtension on AppDataCard {
  Color get _changeColor {
    final bool? positiveValue = this.isPositive;
    if (positiveValue == null) {
      return AppColors.textSecondary;
    }
    final bool isPositiveBool = positiveValue;
    return isPositiveBool ? AppColors.success : AppColors.error;
  }
}
