import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/customize_page.dart';

void main() {

   Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

group('CustomizeProfilePage Widget Tests', () {

testWidgets('AppBar has a back button, title, and logo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));
      await tester.pumpAndSettle(); // Wait for any async operations to complete

      // Verify the presence of the back button
      print('Checking for back button...');
      expect(find.byIcon(Icons.keyboard_backspace), findsOneWidget);

      // Verify the presence of the logo
      print('Checking for CircleAvatar...');
      expect(find.byType(CircleAvatar), findsWidgets);

      // Verify the title is centered
      print('Checking AppBar properties...');
      AppBar appBar = tester.widget(find.byType(AppBar));
      expect(appBar.centerTitle, true);
    });
testWidgets('CustomizeProfilePage has a title and message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: CustomizeProfilePage(),
    ));
     await tester.pumpAndSettle();

     final circleAvatarFinder = find.byKey(const Key('profileCircleAvatar'));
     expect(circleAvatarFinder, findsOneWidget);

    // Verify that CustomizeProfilePage contains the expected Widgets.
    expect(find.text('Customize Profile'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(IconButton), findsWidgets);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // You can also test for specific keys if you have assigned them to your widgets.
    expect(find.byKey(const Key('saveButton')), findsOneWidget);
  });
testWidgets('AppBar has a back button, title, and logo', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CustomizeProfilePage(),
      ));
      await tester.pumpAndSettle(); // Wait for any async operations to complete

      // Verify the presence of the back button
      expect(find.byIcon(Icons.keyboard_backspace), findsOneWidget);

      // Verify the presence of the logo
      expect(find.byType(CircleAvatar), findsWidgets);

      // Verify the title is centered
      AppBar appBar = tester.widget(find.byType(AppBar));
      expect(appBar.centerTitle, true);
    });
  testWidgets('AppBar has a back button, title, and logo', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: CustomizeProfilePage(),
    ));
    await tester.pumpAndSettle(); // Wait for any async operations to complete

     final title = find.text('Customize Profile');
     expect(title, findsOneWidget);

    // Verify the presence of the back button
    print('Checking for back button...');
    expect(find.byIcon(Icons.keyboard_backspace), findsOneWidget);

    // Verify the presence of the logo
    print('Checking for CircleAvatar...');
    expect(find.byType(CircleAvatar), findsWidgets);

    // Verify the title is centered
    print('Checking AppBar properties...');
    AppBar appBar = tester.widget(find.byType(AppBar));
    expect(appBar.centerTitle, true);
  });

  testWidgets('AppBar has a back button, title, and logo', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: CustomizeProfilePage(),
    ));

    // Verify the presence of the back button
   expect(find.byIcon(Icons.keyboard_backspace), findsOneWidget);

    // Verify the presence of the logo
    expect(find.byType(CircleAvatar), findsWidgets);

    // Verify the title is centered
    AppBar appBar = tester.widget(find.byType(AppBar));
    expect(appBar.centerTitle, true);

    expect(find.text('Customize Profile'), findsOneWidget);

  // Verify the profile picture
  expect(find.byType(CircleAvatar), findsNWidgets(2)); // One in AppBar and one in body

  // Verify the "Change picture" text
  expect(find.text('Change picture'), findsOneWidget);
  });

  testWidgets('Body has title, profile picture, and change picture text', (WidgetTester tester) async {
   await tester.pumpWidget(const MaterialApp(
      home: CustomizeProfilePage(),
    ));

  // Verify the title
  expect(find.text('Customize Profile'), findsOneWidget);

  // Verify the profile picture
  expect(find.byType(CircleAvatar), findsNWidgets(2)); // One in AppBar and one in body

  // Verify the "Change picture" text
  expect(find.text('Change picture'), findsOneWidget);
});

  testWidgets('CustomizeProfilePage has a title and message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: CustomizeProfilePage(),
    ));

    // Verify that CustomizeProfilePage contains the expected Widgets.
    //expect(find.text('Customize Profile'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(IconButton), findsWidgets);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // You can also test for specific keys if you have assigned them to your widgets.
    expect(find.byKey(const Key('saveButton')), findsOneWidget);
  });

/*testWidgets('Genre section has title and add button', (WidgetTester tester) async {
  await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

  // Verify the genre title
  expect(find.text('Genre'), findsOneWidget);

  // Verify the add button
  expect(find.byIcon(Icons.add), findsNWidgets(3)); // There are three add buttons in the page
});

testWidgets('Age rating section has title and add button', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));


  // Verify the age rating title
  expect(find.text('Age rating '), findsOneWidget);

  // Verify the add button
  expect(find.byIcon(Icons.add), findsNWidgets(3)); // There are three add buttons in the page
});

testWidgets('Social interests section has title and add button', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

  // Verify the social interests title
  expect(find.text('Social interests '), findsOneWidget);

  // Verify the add button
  expect(find.byIcon(Icons.add), findsNWidgets(3)); // There are three add buttons in the page
});

testWidgets('Dark mode section has title and switch', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

  // Verify the dark mode title
  expect(find.text('Dark mode:'), findsOneWidget);

  // Verify the switch
  expect(find.byType(Switch), findsOneWidget);
});

testWidgets('Page has a save button', (WidgetTester tester) async {
     await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

  // Verify the save button
  expect(find.byKey(const Key('saveButton')), findsOneWidget);

  // Verify the save button text
  expect(find.text('Save Changes'), findsOneWidget);
});*/


  testWidgets('Switch toggles dark mode', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: CustomizeProfilePage(),
    ));

    // Find the dark mode Switch.
    final darkModeSwitch = find.byType(Switch);

    // Tap the switch and rebuild the widget with the new state.
    await tester.tap(darkModeSwitch);
    await tester.pump();

    // Verify that the Switch can be tapped and is on.
    final Switch switchWidget = tester.widget(darkModeSwitch);
    expect(switchWidget.value, isTrue);
  });

  testWidgets('Genres can be selected', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: CustomizeProfilePage(),
    ));

    // Find the genre selection button.
    final genreButton = find.byIcon(Icons.add);

    // Tap the button to open the selection dialog.
    await tester.tap(genreButton);
    await tester.pump(); // Rebuild the widget after the state has changed.

    // Check if the dialog is displayed.
    expect(find.byType(SelectableDialog), findsOneWidget);

    // You would continue here to simulate selecting a genre and saving it.
  });
  });
}
