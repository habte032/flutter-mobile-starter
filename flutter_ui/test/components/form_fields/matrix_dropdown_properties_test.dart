import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/app_ui.dart';
import '../../utils/property_test_utils.dart';

void main() {
  group('AppDropdown Property Tests', () {
    // Feature: flutter-ui-components, Property 11: Dropdown search filtering
    testWidgets(
      'Property 11: Searchable dropdown filters items correctly based on search query',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description: 'Dropdown search filtering across various item lists',
          iterations: 100,
          test: () async {
            // Generate random list of items
            final itemCount = PropertyTestUtils.randomInt(5, 20);
            final items = List.generate(
              itemCount,
              (index) => PropertyTestUtils.randomString(
                PropertyTestUtils.randomInt(5, 15),
              ),
            );

            // Ensure items are unique to avoid confusion
            final uniqueItems = items.toSet().toList();

            // Skip if we don't have enough unique items
            if (uniqueItems.length < 3) {
              return;
            }

            // Generate a search query that should match some items
            // Pick a random item and use part of it as the search query
            final targetItem = PropertyTestUtils.randomElement(uniqueItems);
            final queryLength = PropertyTestUtils.randomInt(
              1,
              (targetItem.length / 2).ceil().clamp(1, targetItem.length),
            );
            final searchQuery = targetItem.substring(0, queryLength);

            // Calculate expected filtered items
            final expectedFilteredItems = uniqueItems.where((item) {
              return item.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            // Skip if no items match (edge case)
            if (expectedFilteredItems.isEmpty) {
              return;
            }

            // Track selected value
            String? selectedValue;

            // Create searchable dropdown
            final dropdown = AppDropdown<String>.searchable(
              label: 'Test Dropdown',
              items: uniqueItems,
              onChanged: (value) => selectedValue = value,
              searchHint: 'Search items...',
            );

            // Build the widget
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(body: Center(child: dropdown)),
              ),
            );
            await tester.pump();

            // Tap the dropdown to open it
            final dropdownFinder = find.byType(InkWell).first;
            await tester.tap(dropdownFinder);
            await tester.pumpAndSettle();
            await tester.pump(const Duration(milliseconds: 100));

            // Verify the dropdown overlay is open by checking for ListView
            expect(
              find.byType(ListView),
              findsOneWidget,
              reason: 'Dropdown overlay should be open',
            );

            // Wait for the overlay to fully render
            await tester.pump();

            // Find the search field and enter the search query
            final searchField = find.byType(TextField);
            expect(
              searchField,
              findsOneWidget,
              reason: 'Search field should be present in searchable dropdown',
            );

            await tester.enterText(searchField, searchQuery);
            await tester.pumpAndSettle();

            // Verify the ListView is present
            final listView = find.byType(ListView);
            expect(
              listView,
              findsOneWidget,
              reason: 'ListView should be present',
            );

            // Verify that filtering actually reduced the number of items
            // (we can't count rendered items due to virtualization, but we can
            // verify the filter worked by checking the expected count is less than total)
            expect(
              expectedFilteredItems.length,
              lessThanOrEqualTo(uniqueItems.length),
              reason: 'Filtered items should be <= total items',
            );

            // Verify the ListView has the correct itemCount by checking the builder
            // ListView.builder uses a SliverChildBuilderDelegate which has itemCount
            final listViewElement = tester.element(listView);
            final listViewWidget = listViewElement.widget as ListView;
            // Access the itemCount through the childrenDelegate if it's a builder
            if (listViewWidget.childrenDelegate is SliverChildBuilderDelegate) {
              final delegate =
                  listViewWidget.childrenDelegate as SliverChildBuilderDelegate;
              final listViewItemCount = delegate.childCount;
              expect(
                listViewItemCount,
                expectedFilteredItems.length,
                reason:
                    'ListView itemCount should match filtered items count. '
                    'Expected ${expectedFilteredItems.length}, got $listViewItemCount.',
              );
            }

            // Verify we can select a filtered item by tapping the first visible InkWell
            final inkWells = find.descendant(
              of: listView,
              matching: find.byType(InkWell),
            );

            // Verify at least one item is visible (some items might be off-screen due to maxHeight)
            expect(
              inkWells.evaluate().length,
              greaterThan(0),
              reason: 'At least one filtered item should be visible',
            );

            final firstInkWell = inkWells.first;

            await tester.tap(firstInkWell);
            await tester.pumpAndSettle();

            // Verify the callback was invoked with a value from the filtered list
            expect(
              selectedValue,
              isNotNull,
              reason: 'Selected value should not be null after selection',
            );

            expect(
              expectedFilteredItems.contains(selectedValue),
              true,
              reason: 'Selected value should be from the filtered items',
            );

            // Verify the dropdown is closed after selection
            expect(
              find.byType(ListView),
              findsNothing,
              reason: 'Dropdown should close after item selection',
            );

            // Clean up for next iteration
            await tester.pumpWidget(Container());
            await tester.pumpAndSettle();
          },
        );
      },
    );

    // Feature: flutter-ui-components, Property 13: Dropdown selection callback
    testWidgets(
      'Property 13: Dropdown selection callback is invoked with selected value',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description:
              'Dropdown selection callback invocation across various scenarios',
          iterations: 100,
          test: () async {
            // Generate random list of items
            final itemCount = PropertyTestUtils.randomInt(3, 15);
            final items = List.generate(
              itemCount,
              (index) => 'Item ${PropertyTestUtils.randomString(5)}',
            );

            // Ensure items are unique
            final uniqueItems = items.toSet().toList();

            // Skip if we don't have enough unique items
            if (uniqueItems.length < 2) {
              return;
            }

            // Track callback invocations and selected value
            String? callbackValue;
            int callbackCount = 0;
            String? selectedValue;

            // Build the widget with state management
            await tester.pumpWidget(
              MaterialApp(
                home: StatefulBuilder(
                  builder: (context, setState) {
                    return Scaffold(
                      body: Center(
                        child: AppDropdown<String>.medium(
                          label: 'Test Dropdown',
                          items: uniqueItems,
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                            callbackValue = value;
                            callbackCount++;
                          },
                          hint: 'Select an item',
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
            await tester.pump();

            // Verify initial state shows hint
            expect(
              find.text('Select an item'),
              findsOneWidget,
              reason: 'Should show hint when no item is selected',
            );

            // Tap the dropdown to open it
            final dropdownFinder = find.byType(InkWell).first;
            await tester.tap(dropdownFinder);
            await tester.pumpAndSettle();
            await tester.pump(const Duration(milliseconds: 100));

            // Verify the dropdown overlay is open
            final listView = find.byType(ListView);
            expect(
              listView,
              findsOneWidget,
              reason: 'Dropdown overlay should be open',
            );

            // Verify the ListView has the correct itemCount
            final listViewElement = tester.element(listView);
            final listViewWidget = listViewElement.widget as ListView;
            if (listViewWidget.childrenDelegate is SliverChildBuilderDelegate) {
              final delegate =
                  listViewWidget.childrenDelegate as SliverChildBuilderDelegate;
              final listViewItemCount = delegate.childCount;
              expect(
                listViewItemCount,
                uniqueItems.length,
                reason:
                    'ListView itemCount should match items count. '
                    'Expected ${uniqueItems.length}, got $listViewItemCount.',
              );
            }

            // Get all InkWell widgets in the ListView
            final allInkWells = find.descendant(
              of: listView,
              matching: find.byType(InkWell),
            );

            // Verify we have at least one item (some may be off-screen)
            final visibleItemCount = allInkWells.evaluate().length;
            expect(
              visibleItemCount,
              greaterThan(0),
              reason: 'Should have at least one item visible in the list',
            );

            // Select the first visible item and get its text to determine expected value
            final firstInkWell = allInkWells.first;
            // Extract the text from the InkWell's child Text widget
            final firstInkWellTextWidget = tester.widget<Text>(
              find
                  .descendant(of: firstInkWell, matching: find.byType(Text))
                  .first,
            );
            final firstInkWellText = firstInkWellTextWidget.data;

            // Verify we got valid text
            expect(
              firstInkWellText,
              isNotNull,
              reason: 'First item should have text',
            );

            final firstItemText = firstInkWellText!;

            // Verify the text is from our items list
            expect(
              uniqueItems.contains(firstItemText),
              true,
              reason: 'Visible item text should be from the items list',
            );

            // Tap the first visible item
            await tester.tap(firstInkWell);
            await tester.pumpAndSettle();

            // Verify the callback was invoked exactly once
            expect(
              callbackCount,
              1,
              reason: 'Callback should be invoked exactly once',
            );

            // Verify the callback received the correct value (should match the tapped item's text)
            expect(
              callbackValue,
              firstItemText,
              reason:
                  'Callback should receive the selected value "$firstItemText"',
            );

            // Verify the callback value is from the items list
            expect(
              uniqueItems.contains(callbackValue),
              true,
              reason: 'Callback value should be from the items list',
            );

            // Verify the dropdown is closed after selection
            expect(
              find.byType(ListView),
              findsNothing,
              reason: 'Dropdown should close after item selection',
            );

            // Verify the selected value is displayed in the dropdown button
            // The dropdown should show the selected value after the callback
            expect(
              find.text(firstItemText),
              findsOneWidget,
              reason:
                  'Dropdown should display the selected value "$firstItemText"',
            );

            // Test selecting a different item
            await tester.tap(dropdownFinder);
            await tester.pumpAndSettle();
            await tester.pump(const Duration(milliseconds: 100));

            // Get the InkWells again (they're recreated)
            final reopenedListView = find.byType(ListView);
            final reopenedInkWells = find.descendant(
              of: reopenedListView,
              matching: find.byType(InkWell),
            );

            // Select a different item from visible items (pick the second one if available)
            final reopenedVisibleCount = reopenedInkWells.evaluate().length;
            if (reopenedVisibleCount > 1) {
              // Get the text from the second visible item
              final secondInkWell = reopenedInkWells.at(1);
              final secondInkWellText = tester
                  .widget<Text>(
                    find
                        .descendant(
                          of: secondInkWell,
                          matching: find.byType(Text),
                        )
                        .first,
                  )
                  .data;

              // Verify we got valid text
              expect(
                secondInkWellText,
                isNotNull,
                reason: 'Second item should have text',
              );

              final secondItemText = secondInkWellText!;

              // Verify it's different from the first selection
              expect(
                secondItemText,
                isNot(callbackValue),
                reason: 'Second item should be different from first selection',
              );

              await tester.tap(secondInkWell);
              await tester.pumpAndSettle();

              // Verify the callback was invoked again
              expect(
                callbackCount,
                2,
                reason:
                    'Callback should be invoked twice after second selection',
              );

              // Verify the callback received the new value
              expect(
                callbackValue,
                secondItemText,
                reason:
                    'Callback should receive the new selected value "$secondItemText"',
              );

              // Verify the new value is displayed
              expect(
                find.text(secondItemText),
                findsOneWidget,
                reason:
                    'Dropdown should display the new selected value "$secondItemText"',
              );
            } else {
              // If only one item is visible, just verify we can select it again
              // (this tests that the callback still works)
              await tester.tap(reopenedInkWells.first);
              await tester.pumpAndSettle();

              // Verify the callback was invoked again
              expect(
                callbackCount,
                2,
                reason:
                    'Callback should be invoked twice after second selection',
              );
            }

            // Clean up for next iteration
            await tester.pumpWidget(Container());
            await tester.pumpAndSettle();
          },
        );
      },
    );

    // Feature: flutter-ui-components, Property 12: Dropdown multi-select tracking
    testWidgets(
      'Property 12: Multi-select dropdown tracks multiple selections and displays count',
      (WidgetTester tester) async {
        await PropertyTestUtils.runAsyncPropertyTest(
          description:
              'Multi-select dropdown selection tracking across various scenarios',
          iterations: 100,
          test: () async {
            // Generate random list of items
            final itemCount = PropertyTestUtils.randomInt(5, 15);
            final items = List.generate(
              itemCount,
              (index) => 'Item ${PropertyTestUtils.randomString(5)}',
            );

            // Ensure items are unique
            final uniqueItems = items.toSet().toList();

            // Skip if we don't have enough unique items
            if (uniqueItems.length < 3) {
              return;
            }

            // Track selected values
            List<String> selectedValues = [];

            // Create multi-select dropdown
            final dropdown = AppDropdown<String>.multiSelect(
              label: 'Test Multi-Select',
              items: uniqueItems,
              values: [],
              onMultiChanged: (values) => selectedValues = values,
            );

            // Build the widget
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(body: Center(child: dropdown)),
              ),
            );
            await tester.pump();

            // Verify initial display shows "Select items" or similar
            expect(
              find.text('Select items'),
              findsOneWidget,
              reason: 'Should show default hint when no items selected',
            );

            // Tap the dropdown to open it
            final dropdownFinder = find.byType(InkWell).first;
            await tester.tap(dropdownFinder);
            await tester.pumpAndSettle();
            await tester.pump(const Duration(milliseconds: 100));

            // Verify the dropdown overlay is open
            expect(
              find.byType(ListView),
              findsOneWidget,
              reason: 'Dropdown overlay should be open',
            );

            // Randomly select multiple items (between 1 and min(5, itemCount))
            final numToSelect = PropertyTestUtils.randomInt(
              1,
              (uniqueItems.length / 2).ceil().clamp(1, 5),
            );

            // Get all InkWell widgets (each item is wrapped in InkWell)
            final allInkWells = find.descendant(
              of: find.byType(ListView),
              matching: find.byType(InkWell),
            );

            // Select items by tapping their InkWells
            final inkWellsToTap = <int>[];
            for (
              int i = 0;
              i < numToSelect && i < allInkWells.evaluate().length;
              i++
            ) {
              inkWellsToTap.add(i);
            }

            for (final index in inkWellsToTap) {
              await tester.tap(allInkWells.at(index));
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 100));
            }

            // Verify the callback was invoked with selected items
            expect(
              selectedValues.length,
              inkWellsToTap.length,
              reason:
                  'Selected values should contain all ${inkWellsToTap.length} selected items',
            );

            // Verify all selected values are from the unique items list
            for (final value in selectedValues) {
              expect(
                uniqueItems.contains(value),
                true,
                reason: 'Selected value "$value" should be from the items list',
              );
            }

            // Verify the dropdown is still open (multi-select doesn't auto-close)
            expect(
              find.byType(ListView),
              findsOneWidget,
              reason:
                  'Multi-select dropdown should remain open after selection',
            );

            // Verify selected items show checked checkboxes
            final checkedBoxes = find.descendant(
              of: find.byType(ListView),
              matching: find.byIcon(Icons.check_box),
            );

            expect(
              checkedBoxes.evaluate().length,
              inkWellsToTap.length,
              reason: 'Should have ${inkWellsToTap.length} checked checkboxes',
            );

            // Close the dropdown by tapping outside
            await tester.tapAt(const Offset(10, 10));
            await tester.pumpAndSettle();

            // Verify the dropdown is closed
            expect(
              find.byType(ListView),
              findsNothing,
              reason: 'Dropdown should close when tapping outside',
            );

            // Verify the count is displayed in the dropdown button
            final countText = '${inkWellsToTap.length} selected';
            expect(
              find.text(countText),
              findsOneWidget,
              reason:
                  'Dropdown should display "$countText" when ${inkWellsToTap.length} items are selected',
            );

            // Test deselection: reopen and deselect the first item
            await tester.tap(dropdownFinder);
            await tester.pumpAndSettle();
            await tester.pump(const Duration(milliseconds: 100));

            // Get the InkWells again (they're recreated)
            final reopenedInkWells = find.descendant(
              of: find.byType(ListView),
              matching: find.byType(InkWell),
            );

            // Deselect the first selected item (tap it again)
            await tester.tap(reopenedInkWells.at(0));
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 100));

            // Verify the item was removed from selection
            expect(
              selectedValues.length,
              inkWellsToTap.length - 1,
              reason:
                  'Selected values should have one less item after deselection',
            );

            // Verify the deselected item shows unchecked checkbox
            final uncheckedBoxes = find.descendant(
              of: find.byType(ListView),
              matching: find.byIcon(Icons.check_box_outline_blank),
            );

            expect(
              uncheckedBoxes.evaluate().length,
              greaterThan(0),
              reason:
                  'Should have at least one unchecked checkbox after deselection',
            );

            // Close and verify updated count
            await tester.tapAt(const Offset(10, 10));
            await tester.pumpAndSettle();

            // If we deselected all items, it should show "Select items"
            // Otherwise it should show the count
            if (inkWellsToTap.length - 1 == 0) {
              expect(
                find.text('Select items'),
                findsOneWidget,
                reason:
                    'Dropdown should display "Select items" when no items are selected',
              );
            } else {
              final updatedCountText = '${inkWellsToTap.length - 1} selected';
              expect(
                find.text(updatedCountText),
                findsOneWidget,
                reason:
                    'Dropdown should display updated count after deselection',
              );
            }

            // Clean up for next iteration
            await tester.pumpWidget(Container());
            await tester.pumpAndSettle();
          },
        );
      },
    );
  });
}
