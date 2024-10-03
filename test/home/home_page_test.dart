import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gameonconnect/view/pages/home/home_page.dart';
import '../mock.dart'; 


void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    // Ensure Firebase and dotenv are initialized before running tests
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
  });

  group('HomePage UI Tests', () {
    testWidgets('HomePage loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage(title: 'GameOnConnect',)));
      await tester.pumpAndSettle();
      await tester.pump();

    });

    testWidgets('Bottom navigation bar loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage(title: 'GameOnConnect',)));
      await tester.pumpAndSettle();
      await tester.pump();

      expect(find.byKey(const Key('nav_home')), findsOneWidget);
      expect(find.byKey(const Key('nav_search')), findsOneWidget);
      expect(find.byKey(const Key('nav_gamepad')), findsOneWidget);
      expect(find.byKey(const Key('nav_calendar')), findsOneWidget);
      expect(find.byKey(const Key('nav_person')), findsOneWidget);
    });
  });
}