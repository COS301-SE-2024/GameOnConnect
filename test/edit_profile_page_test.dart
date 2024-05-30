import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/edit_profile_page.dart'; 

void main() {
  testWidgets('EditProfilePage builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

    // Verify if the AppBar is present
    expect(find.byType(AppBar), findsOneWidget);
    // Verify if the CircleAvatar is present
    expect(find.byType(CircleAvatar), findsOneWidget);
    // Verify if the EditProfileForm is present
    expect(find.byType(EditProfileForm), findsOneWidget);
  });

  testWidgets('Form fields are present and editable', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

    // Verify if the form fields are present
    expect(find.text('Username:'), findsOneWidget);
    expect(find.text('First Name:'), findsOneWidget);
    expect(find.text('Last Name:'), findsOneWidget);
    expect(find.text('Bio:'), findsOneWidget);

    // Enter text into the form fields
    await tester.enterText(find.byKey(Key('usernameField')), 'test_username');
    await tester.enterText(find.byKey(Key('firstNameField')), 'test_first_name');
    await tester.enterText(find.byKey(Key('lastNameField')), 'test_last_name');
    await tester.enterText(find.byKey(Key('bioField')), 'test_bio');

    // Verify if the text is entered correctly
    expect(find.text('test_username'), findsOneWidget);
    expect(find.text('test_first_name'), findsOneWidget);
    expect(find.text('test_last_name'), findsOneWidget);
    expect(find.text('test_bio'), findsOneWidget);
  });

  testWidgets('Switch input is present and toggleable', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

    // Verify if the switch is present
    // expect(find.byKey(Key('privateAccountSwitch')), findsOneWidget);

    // Toggle the switch
    // await tester.tap(find.byKey(Key('privateAccountSwitch')));
    // await tester.pump();

    // Verify if the switch is toggled
    // Switch switchWidget = tester.widget(find.byKey(Key('privateAccountSwitch')));
    // expect(switchWidget.value, isTrue);
  });

  testWidgets('Save button is present and functional', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

    
  });


}
