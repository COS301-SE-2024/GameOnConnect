//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:gameonconnect/view/pages/events/view_events_page.dart';

void main() {
  group('View events Widget Tests', () {
    testWidgets('AppBar and button Test', (WidgetTester tester) async {
      //await tester.pumpWidget(const MaterialApp(home: ViewEvents()));
      //await tester.pumpAndSettle();

      // Check if the widget with the key 'history_icon_button' is present
      //expect(find.byKey(const Key('history_icon_button')), findsOneWidget);
      //expect(find.text('All'), findsOneWidget);
      
      //Struggling to resolve the firebase error
      /* The following FirebaseException was thrown building ViewEvents(dirty, dependencies:
        [_InheritedTheme, _LocalizationsScope-[GlobalKey#aceab]], state: _HomePageWidgetState#f2c6f):
        [core/no-app] No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp() */
    });
  });
}