import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'login_integration_test.dart';

void main() {
  group('Search Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets("Search Page Test", (tester) async {
      await login(tester);
      await tester.pump(const Duration(seconds: 2));

      final homeIcon = find.byIcon(Icons.home_filled);
      final searchIcon = find.byIcon(Icons.search);
      final gamepadIcon = find.byIcon(Icons.gamepad_rounded);
      final calendarIcon = find.byIcon(Icons.calendar_today);
      final personIcon = find.byIcon(Icons.person);

      expect(homeIcon, findsOneWidget, reason: "Home icon not found");
      expect(searchIcon, findsOneWidget, reason: "Search icon not found");
      expect(gamepadIcon, findsOneWidget, reason: "Gamepad icon not found");
      expect(calendarIcon, findsOneWidget, reason: "Calendar icon not found");
      expect(personIcon, findsOneWidget, reason: "Person icon not found");

      await tester.tap(searchIcon);
      await tester.pump(const Duration(seconds: 3));

      var searchField = find.byKey(const Key('searchTextField'));
      await tester.enterText(searchField, 'the witcher 3');
      await tester.pump();
      await Future.delayed(const Duration(seconds: 2));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 12));
      await Future.delayed(const Duration(seconds: 2));

      return;
    });
  });
}
