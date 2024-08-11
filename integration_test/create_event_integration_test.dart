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

      //tap on the name field and enter a name
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

      //scroll the page down
      final scrollableFinder = find.byKey(
        const Key('createEventScroll'),
      );
      await tester.drag(scrollableFinder, const Offset(0, -300));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      //select counterstrike as the game
      var gameSelector = find.byKey(
        const Key('gameSelector'),
      );
      await tester.tap(gameSelector);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      var game = find.text('Counter-Strike: Global Offensive');
      await tester.tap(game);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      //save the game that was chosen
      var saveButton = find.byKey(
        const Key('save_game_button'),
      );
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      //tap on the description field and enter a description
      var descriptionTextField = find.byKey(
        const Key('descriptionTextField'),
      );
      await tester.enterText(
          descriptionTextField, 'This is a description test.');
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      //start the process of choosing a time to start the event
      var startDatePicker = find.byKey(const Key('start_date_picker'));
      await tester.tap(startDatePicker);
      await tester.pumpAndSettle();

      await tester.tap(find.text('14'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      //start the process of choosing a time to end the event
      var endDatePicker = find.byKey(
       const Key('end_date_picker'),
      );
      await tester.tap(endDatePicker);
      await tester.pumpAndSettle();

      await tester.tap(find.text('16'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      //tap on the privacy switch
      var privacySwitch = find.byKey(
         const Key('switch'),
      );
      await tester.tap(privacySwitch);
       await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      //scroll the page down
      await tester.drag(scrollableFinder, const Offset(0, -300));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      var createButton = find.byKey(
        const Key('create_event_button'),
      );
      await tester.tap(createButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      return;
    });
  });
}
