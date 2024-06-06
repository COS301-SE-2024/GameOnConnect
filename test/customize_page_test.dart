import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/customize_page.dart';


void main() {
  
  testWidgets('SelectableDialog shows items and responds to selection', (WidgetTester tester) async {
    // Define a list of items to be used in the dialog.
    List<String> testItems = ['Action', 'Adventure', 'Puzzle'];

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: SelectableDialog(title: 'Select Genre', items: testItems),
      ),
    );

    // Verify that the dialog title 'Select Genre' is present.
    expect(find.text('Select Genre'), findsOneWidget);

    // Verify that all items are present.
    for (String item in testItems) {
      expect(find.text(item), findsOneWidget);
    }

    // Tap on the first checkbox to select it.
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pump();

    // Verify that the submit button is present and can be tapped.
    expect(find.text('Submit'), findsOneWidget);
    await tester.tap(find.text('Submit'));
    await tester.pump();
  });
}