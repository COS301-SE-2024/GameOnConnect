//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/annotations.dart';
//import 'package:provider/provider.dart';
//import 'package:mockito/mockito.dart';
//import 'package:gameonconnect/theme/theme_provider.dart';
import 'package:gameonconnect/pages/customize_page.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';

//import 'customize_page_test.mocks.dart';
//import 'mocks/mock_http_client.dart'; // Import the mock client


// Create a mock class for FirebaseAuth using the mockito package.
//class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Create a mock class for FirebaseFirestore using the mockito package.
//class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

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

  /*testWidgets('CustomizeProfilePage UI Test', (WidgetTester tester) async {
    // Create a mock client.
    final mockHttpClient = MockClient();

    // Set up the mock client to return a valid response.
    when(mockHttpClient.get(any)).thenAnswer(
      (_) async => http.Response(jsonEncode({'results': []}), 200),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: CustomizeProfilePage( httpClient: mockHttpClient),
      ),
    );
     await tester.pumpAndSettle();
      await tester.pump();

    // Verify that the page title is displayed.
    expect(find.text('Customize Profile'), findsOneWidget);

    // Verify that the profile picture is displayed.
    expect(find.byType(CircleAvatar), findsWidgets); // Adjusted to findsWidgets if there are multiple CircleAvatars

    // Verify that the "Change picture" text is displayed.
    expect(find.text('Change picture'), findsOneWidget);

    // Verify that the genre section is displayed.
    expect(find.text('Genre'), findsOneWidget);

    // Verify that the age rating section is displayed.
    expect(find.text('Age rating'), findsOneWidget);

    // Verify that the social interests section is displayed.
    expect(find.text('Social interests'), findsOneWidget);

    // Verify that the Dark mode switch is displayed.
    expect(find.byType(Switch), findsOneWidget);

    // Verify that the "Save Changes" button is displayed.
    expect(find.text('Save Changes'), findsOneWidget);
  });*/

  /*testWidgets('CustomizeProfilePage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CustomizeProfilePage());
    await tester.pumpAndSettle();

    // Verify that the page title is displayed.
    expect(find.text('Customize Profile'), findsOneWidget);

    // Verify that the profile picture is displayed.
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Verify that the "Change picture" text is displayed.
    expect(find.text('Change picture'), findsOneWidget);

    // Verify that the genre section is displayed.
    expect(find.text('Genre'), findsOneWidget);

    // Verify that the age rating section is displayed.
    expect(find.text('Age rating'), findsOneWidget);

    // Verify that the social interests section is displayed.
    expect(find.text('Social interests'), findsOneWidget);

    // Verify that the Dark mode switch is displayed.
    expect(find.byType(Switch), findsOneWidget);

    // Verify that the "Save Changes" button is displayed.
    expect(find.text('Save Changes'), findsOneWidget);
  });*/

  // Add more tests as needed to cover different aspects of the widget.
}
/*void main() {
  testWidgets('CustomizeProfilePage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CustomizeProfilePage());
    await tester.pumpAndSettle();

    // Verify that the page title is displayed.
    expect(find.text('Customize Profile'), findsOneWidget);

    // Verify that the profile picture is displayed.
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Verify that the "Change picture" text is displayed.
    expect(find.text('Change picture'), findsOneWidget);

    // Verify that the genre section is displayed.
    expect(find.text('Genre'), findsOneWidget);

    // Verify that the age rating section is displayed.
    expect(find.text('Age rating'), findsOneWidget);

    // Verify that the social interests section is displayed.
    expect(find.text('Social interests'), findsOneWidget);

    // Verify that the Dark mode switch is displayed.
    expect(find.byType(Switch), findsOneWidget);

    // Verify that the "Save Changes" button is displayed.
    expect(find.text('Save Changes'), findsOneWidget);
  });
}*/