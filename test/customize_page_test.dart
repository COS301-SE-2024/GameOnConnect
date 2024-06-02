import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:gameonconnect/theme/theme_provider.dart';
import 'package:gameonconnect/pages/customize_page.dart';

import 'customize_page_test.mocks.dart';

@GenerateMocks([
  http.Client,
  FirebaseAuth,
  User,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  ThemeProvider,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Define the mock clients
  final mockHttpClient = MockClient();
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockUser = MockUser();
  final mockFirestore = MockFirebaseFirestore();
  final mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
  final mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
  final mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
  final mockThemeProvider = MockThemeProvider();

 /* setUp(() {
    // Set up the mocks with default behaviors
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockFirestore.collection('profile_data')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
  });*/

  group('CustomizeProfilePage', () {
    testWidgets('CustomizeProfilePage has a title and message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: CustomizeProfilePage(),
    ));

    // Verify that CustomizeProfilePage contains the expected Widgets.
    expect(find.text('Customize Profile'), findsOneWidget);
    //expect(find.byType(CircleAvatar), findsOneWidget);
    //expect(find.byType(IconButton), findsWidgets);
    //expect(find.byType(Switch), findsOneWidget);
    //expect(find.byType(ElevatedButton), findsOneWidget);

    // You can also test for specific keys if you have assigned them to your widgets.
    //expect(find.byKey(const Key('saveButton')), findsOneWidget);
  });

    /*test('_fetchGenres updates genres correctly', () async {
      // Arrange: Create a mock HTTP client and use it to return a predefined response
      final client = MockClient();
      when(client.get(Uri.parse('https://api.rawg.io/api/genres?key=b8d81a8e79074f1eb5c9961a9ffacee6')))
          .thenAnswer((_) async => http.Response('{"results": [{"name": "Action"}, {"name": "Adventure"}]}', 200));

      // Act: Call _fetchGenres
      final customizeProfilePageObject = CustomizeProfilePageObject();
      customizeProfilePageObject.client = client; // Inject the mock client
      await customizeProfilePageObject.fetchGenres();

      // Assert: Check that the genres list is updated correctly
      expect(customizeProfilePageObject.genres, equals(['Action', 'Adventure']));
    });*/

    /*testWidgets('Fetch genres and interests', (WidgetTester tester) async {
    final customizeProfilePage = CustomizeProfilePageObject();
    final client = MockClient();

    // Define the behavior of the mock HTTP client
    when(client.get(Uri.parse('https://api.rawg.io/api/genres?key=YOUR_API_KEY')))
        .thenAnswer((_) async => http.Response('{"results": [{"name": "Action"}, {"name": "Adventure"}]}', 200));
    when(client.get(Uri.parse('https://api.rawg.io/api/tags?key=YOUR_API_KEY')))
        .thenAnswer((_) async => http.Response('{"results": [{"name": "Gaming"}, {"name": "Movies"}]}', 200));

    // Inject the mock client into your CustomizeProfilePageObject
    customizeProfilePage.client = client;

    // Ensure the CustomizeProfilePageObject is in a widget tree
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CustomizeProfilePage)));

    // Call the methods to fetch genres and interests
    await customizeProfilePage.fetchGenres();
    await customizeProfilePage.fetchTags(); // Make sure this is public too

    // Verify that the genres and interests lists are updated correctly
    expect(customizeProfilePage.genres, equals(['Action', 'Adventure']));
    expect(customizeProfilePage.interests, equals(['Gaming', 'Movies'])); // Make sure this is public too
  });
testWidgets('Show selectable dialog', (WidgetTester tester) async {
  final customizeProfilePage = CustomizeProfilePageObject();
  await tester.pumpWidget(MaterialApp(home: CustomizeProfilePage));

  // Trigger the dialog
  await customizeProfilePage._showSelectableDialog(
    'Select Genre',
    ['Action', 'Adventure'],
    (results) {
      customizeProfilePage._selectedGenres = results;
    },
  );

  // Verify that selected genres are updated
  expect(customizeProfilePage._selectedGenres, equals(['Action', 'Adventure']));
});*/

    /*testWidgets('fetches and displays genres', (WidgetTester tester) async {
      // Mock the HTTP response
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(json.encode({
        'results': [{'name': 'Action'}, {'name': 'Adventure'}]
      }), 200));

      // Build the widget
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: mockThemeProvider,
          child: MaterialApp(
            home: CustomizeProfilePage(),
          ),
        ),
      );

      // Verify the HTTP request
      verify(mockHttpClient.get(any)).called(1);

      // Rebuild the widget with the data
      await tester.pump();

      // Check if the genres are displayed
      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Adventure'), findsOneWidget);
    });

    testWidgets('saves profile data', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: mockThemeProvider,
          child: MaterialApp(
            home: CustomizeProfilePage(),
          ),
        ),
      );

      // Interact with the widget
      await tester.tap(find.byKey(Key('saveButton')));
      await tester.pump();

      // Verify that the profile data was saved
      verify(mockDocumentReference.set(any, SetOptions(merge: true))).called(1);
    });

    // Add more test cases as needed*/
  });
}
