//import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:gameonconnect/firebase_options.dart';
//import 'package:gameonconnect/view/pages/profile/profile_page.dart';

void main() {
  /*final Map<String, dynamic> mockUserProfile = {
    'uid': 'mockUserId',
    'isOwnProfile': true,
    'isConnection': false,
    'loggedInUser': 'mockUserId',
  };

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  });

  group('Profile Page UI Tests', () {
    testWidgets('Profile UI loads', (WidgetTester tester) async {
      // This page needs to be loaded properly before testing the rest of the items
      // At the moment without loading the API data the page is not loading and cannot be tested
      await tester.pumpWidget(
        MaterialApp(
          home: ProfilePage(
            uid: mockUserProfile['uid'],
            isOwnProfile: mockUserProfile['isOwnProfile'],
            isConnection: mockUserProfile['isConnection'],
            loggedInUser: mockUserProfile['loggedInUser'],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Uncomment the appropriate expectations based on your actual UI
      //expect(find.byKey(const Key('loadingScaffold')), findsOneWidget);
      //expect(find.byKey(const Key('errorScaffold')), findsOneWidget);
      //expect(find.byKey(const Key('emptyDataScaffold')), findsOneWidget);
      expect(find.byKey(const Key('settings_icon_button')), findsOneWidget);
    });
  });*/
}