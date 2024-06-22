import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/profile_page.dart';

void main() {
  group('Profile Page UI Tests', () {
    testWidgets('Profile UI loads', (WidgetTester tester) async {
      //This page needs to be loaded properly before testing the rest of the items
      //At the moment without loading the API data the page is not loading and cannot be tested
      await tester.pumpWidget(const MaterialApp(home: Profile()));
      await tester.pumpAndSettle();
      await tester.pump();
      
      //expect(find.byKey(const Key('loadingScaffold'),), findsOneWidget);
      //expect(find.byKey(const Key('errorScaffold'),), findsOneWidget);
      expect(find.byKey(const Key('emptyDataScaffold'),), findsOneWidget);
      //expect(find.byKey(const Key('settings_icon_button')), findsOneWidget);

    });
  });
}