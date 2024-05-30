import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/customize_page.dart';

void main() {
  // Helper function to create the widget under test
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  group('CustomizeProfilePage Widget Tests', () {
    testWidgets('should have a back button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Verify if the back button is present
      expect(find.byIcon(Icons.keyboard_backspace), findsOneWidget);
    });

    testWidgets('should have a title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Verify if the title is present
      expect(find.text('Customize Profile'), findsOneWidget);
    });

    testWidgets('should have a dark mode switch', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Verify if the switch is present
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('should toggle dark mode switch', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Verify initial state of the switch
      expect(find.byType(Switch), findsOneWidget);
      Switch darkModeSwitch = tester.widget(find.byType(Switch));
      expect(darkModeSwitch.value, isFalse);

      // Tap the switch to change its state
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Verify if the switch state has changed
      darkModeSwitch = tester.widget(find.byType(Switch));
      expect(darkModeSwitch.value, isTrue);
    });

    //expect(find.text('Save Changes'), findsOneWidget);

testWidgets('should have a save button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Wait for all frames to settle
      await tester.pumpAndSettle();

      // Verify if the save button is present
      expect(find.byKey(const Key('saveButton')), findsOneWidget);
    });

    testWidgets('should have a save button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));
      await tester.pumpAndSettle();

      // Verify if the save button is present
      //expect(find.byKey(const Key('saveButton')), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });


    testWidgets('should contain genre buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Verify if social interest buttons are present
      expect(find.byType(CustomButtons), findsWidgets);
      expect(find.text('genre1'), findsOneWidget);
      expect(find.text('genre2'), findsOneWidget);
      expect(find.text('genre3'), findsOneWidget);
    });

    testWidgets('should contain age rating buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Verify if age rating buttons are present
      expect(find.byType(CustomButtons), findsWidgets);
      expect(find.text('Age rating1'), findsOneWidget);
      expect(find.text('Age rating2'), findsOneWidget);
    });

    testWidgets('should contain social interest buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Verify if social interest buttons are present
      expect(find.byType(CustomButtons), findsWidgets);
      expect(find.text('interest1'), findsOneWidget);
      expect(find.text(' interest2'), findsOneWidget);
    });

    testWidgets('should contain AddButton widgets', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const CustomizeProfilePage()));

      // Verify if AddButton widgets are present
      expect(find.byType(AddButton), findsNWidgets(2));
    });
  });
}
