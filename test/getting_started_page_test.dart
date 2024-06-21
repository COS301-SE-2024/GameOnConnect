import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/getting_started_page.dart';

void main() {
  group('Getting started UI Tests', () {
    testWidgets('getting started UI loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GettingStarted()));
      await tester.pumpAndSettle();
      await tester.pump();

      expect(find.byKey(const Key('back_button'),), findsOneWidget);
      expect(find.byKey(const Key('game_library_section'),), findsOneWidget);
      expect(find.byKey(const Key('Friends_section'),), findsOneWidget);
      expect(find.byKey(const Key('getting_started'),), findsOneWidget);
      expect(find.byKey(const Key('game_information_section'),), findsOneWidget); 
    });

    testWidgets('ExpansionTile for friends opens and shows content on tap', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GettingStarted()));

      Finder expansionTileFinder = find.byKey(const Key('how_to_friends_List_tile'));
      //tap on the key
      await tester.tap(expansionTileFinder);
      await tester.pumpAndSettle(); 

      expect(find.byKey(const Key('key_searching_friends')), findsOneWidget);
      
      // now search for the second question
      expansionTileFinder = find.byKey(const Key('how_to_add_friends'));
      await tester.tap(expansionTileFinder);
      await tester.pumpAndSettle(); 

      expect(find.byKey(const Key('key_adding_friends')), findsOneWidget);

      //last question
      expansionTileFinder = find.byKey(const Key('Accepting_friends'));
      await tester.tap(expansionTileFinder);
      await tester.pumpAndSettle(); 

      expect(find.byKey(const Key('key_friend_requests')), findsOneWidget);
    });


  });
}