import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'login_integration_test.dart';

void main() {
  group('Search Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets("Search Page Test", (tester) async {
      await login(tester); //need to login first
      await tester.pump(const Duration(seconds: 2));

      final homeIcon = find.byIcon(Icons.home_filled);
      final searchIcon = find.byIcon(Icons.search);
      final gamepadIcon = find.byIcon(Icons.gamepad_rounded);
      final calendarIcon = find.byIcon(Icons.calendar_today);
      final personIcon = find.byIcon(Icons.person);

      //this is to make sure that the navbar is found
      expect(homeIcon, findsOneWidget, reason: "Home icon not found");
      expect(searchIcon, findsOneWidget, reason: "Search icon not found");
      expect(gamepadIcon, findsOneWidget, reason: "Gamepad icon not found");
      expect(calendarIcon, findsOneWidget, reason: "Calendar icon not found");
      expect(personIcon, findsOneWidget, reason: "Person icon not found");

      //taps on the search icon
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      //finds the searchbar
      var searchField = find.byKey(const Key('searchTextField'));
      await tester.enterText(searchField, 'destiny 2');
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      //indicates the text to search has been filled and submits it.
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      //tap on the search icon
      await tester.tap(find.byKey(const Key('searchButton')));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      return;
    });
  });
}
