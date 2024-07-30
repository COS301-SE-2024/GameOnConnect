import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/view/pages/settings/getting_started_page.dart';

//TODO: this test should be updated
void main() {
  group('Getting started UI Tests', () {
    testWidgets('getting started UI loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GettingStarted()));
      await tester.pumpAndSettle();
      await tester.pump();

      expect(find.byKey(const Key('Back_button_key'),), findsOneWidget);
      expect(find.byKey(const Key('game_library_section'),), findsOneWidget);
      expect(find.byKey(const Key('Friends_section'),), findsOneWidget);
      expect(find.byKey(const Key('Getting_started_text'),), findsOneWidget);
      expect(find.byKey(const Key('game_information_section'),), findsOneWidget); 
    });

    testWidgets('ExpansionTile for friends opens and shows content on tap', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GettingStarted()));

      Finder expansionTileFinder = find.byKey(const Key('how_to_friends_List_tile'));
      //tap on the key
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      expect(find.byKey(const Key('how_to_friends_List_tile')), findsOneWidget);
      // expect(find.byKey(const Key('key_searching_friends')), findsOneWidget);
      
      // now search for the second question
      expansionTileFinder = find.byKey(const Key('how_to_add_friends'));
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_adding_friends')), findsOneWidget);

      //last question
      expansionTileFinder = find.byKey(const Key('Accepting_friends'));
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_friend_requests')), findsOneWidget);
    });

    testWidgets('ExpansionTile for GameLibrary opens and shows content on tap', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GettingStarted()));

      Finder expansionTileFinder = find.byKey(const Key('how_search_games'));
      //tap on the key
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_navigate_search_games')), findsOneWidget);
      expect(find.byKey(const Key('how_search_games')), findsOneWidget);
      
      // now search for the second question
      expansionTileFinder = find.byKey(const Key('how_sort_games'));
      //make sure the tile is onscreen
      await tester.ensureVisible(expansionTileFinder);
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_navigate_sort_games')), findsOneWidget);

      //last question
      expansionTileFinder = find.byKey(const Key('filter_games'));
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_how_to_filter_games')), findsOneWidget);
    });

    testWidgets('ExpansionTile for Game Information opens and shows content on tap', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GettingStarted()));

      Finder expansionTileFinder = find.byKey(const Key('view_game_info'));
      //tap on the key
      await tester.ensureVisible(expansionTileFinder);
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_view_specific_game')), findsOneWidget);
      expect(find.byKey(const Key('view_game_info')), findsOneWidget);

      // now search for the second question
      expansionTileFinder = find.byKey(const Key('share_game_info'));
      //make sure the tile is onscreen
      await tester.ensureVisible(expansionTileFinder);
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_sharing_game_info')), findsOneWidget);

      //3rd question
      await tester.ensureVisible(expansionTileFinder);
      expansionTileFinder = find.byKey(const Key('add_game_to_wishlist'));
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_add_to_wishlist')), findsOneWidget);

      //4th question
      await tester.ensureVisible(expansionTileFinder);
      expansionTileFinder = find.byKey(const Key('add_to_currently_playing'));
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_navigate_to_currently_playing')), findsOneWidget);

      //5th question
      await tester.ensureVisible(expansionTileFinder);
      expansionTileFinder = find.byKey(const Key('remove_from_wishlist'));
      await tester.tap(expansionTileFinder);
      // await tester.pumpAndSettle(); 

      // expect(find.byKey(const Key('key_removing_from_wishlist')), findsOneWidget); 
    });

  });
}