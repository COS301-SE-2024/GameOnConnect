import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'login_integration_test.dart';

void main() {
  group('Create Event Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets("Create Event Page Test", (tester) async {
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
      await tester.tap(gamepadIcon);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      var eventNameTextField = find.byKey(
        const Key('nameTextField'),
      );
      await tester.enterText(eventNameTextField, 'Test Event');
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Scroll down slowly
      final scrollableFinder = find.byKey(const Key('createEventScroll'),);
      await tester.drag(scrollableFinder, const Offset(0, -300)); 
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      var gameSelector = find.byKey(
        const Key('gameSelector'),
      );
      await tester.tap(gameSelector);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      await tester.tap(find.text('Counter-Strike: Global Offensive'));

      return;
    });
  });
}
