import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/view/pages/settings/edit_profile_page.dart';

void main() {
  testWidgets('EditProfilePage UI test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));

    // Verify the AppBar title CircleAvatar
    //expect(find.byKey(const Key('profileAvatar')), findsOneWidget);

    // Verify text fields and their labels
    expect(find.byKey(const Key('usernameField')), findsOneWidget);
    expect(find.text('Username:'), findsOneWidget);

    expect(find.byKey(const Key('firstNameField')), findsOneWidget);
    expect(find.text('First Name:'), findsOneWidget);

    expect(find.byKey(const Key('lastNameField')), findsOneWidget);
    expect(find.text('Last Name:'), findsOneWidget);

    expect(find.byKey(const Key('bioField')), findsOneWidget);
    expect(find.text('Bio:'), findsOneWidget);

    expect(find.byKey(const Key('birthdayField')), findsOneWidget);
    expect(find.text('Birthday:'), findsOneWidget);

    // Verify switch
    // expect(find.byKey(const Key('privateAccountSwitch')), findsOneWidget);
    // expect(find.text('Private Account:'), findsOneWidget);

    // Verify Save Changes button
    expect(find.text('Save Changes'), findsOneWidget);

    // Tap the Save Changes button
    await tester.tap(find.text('Save Changes'));
    await tester.pump();
  });
}






























// //ignore_for_file: prefer_const_constructors
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:gameonconnect/pages/edit_profile_page.dart'; 

// void main() {
//   testWidgets('EditProfilePage builds correctly', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

//     // Verify if the AppBar is present
//     expect(find.byType(AppBar), findsOneWidget);
//     // Verify if the CircleAvatar is present
//     expect(find.byType(CircleAvatar), findsOneWidget);
//     // Verify if the EditProfileForm is present
//     expect(find.byType(EditProfileForm), findsOneWidget);
//   });

//   testWidgets('Form fields are present and editable', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

//     // Verify if the form fields are present
//     expect(find.text('Username:'), findsOneWidget);
//     expect(find.text('First Name:'), findsOneWidget);
//     expect(find.text('Last Name:'), findsOneWidget);
//     expect(find.text('Bio:'), findsOneWidget);

//     // Enter text into the form fields
//     await tester.enterText(find.byKey(Key('usernameField')), 'test_username');
//     await tester.enterText(find.byKey(Key('firstNameField')), 'test_first_name');
//     await tester.enterText(find.byKey(Key('lastNameField')), 'test_last_name');
//     await tester.enterText(find.byKey(Key('bioField')), 'test_bio');

//     // Verify if the text is entered correctly
//     expect(find.text('test_username'), findsOneWidget);
//     expect(find.text('test_first_name'), findsOneWidget);
//     expect(find.text('test_last_name'), findsOneWidget);
//     expect(find.text('test_bio'), findsOneWidget);
//   });

//   testWidgets('Switch input is present and toggleable', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

//     // Verify if the switch is present
//     // expect(find.byKey(Key('privateAccountSwitch')), findsOneWidget);

//     // Toggle the switch
//     // await tester.tap(find.byKey(Key('privateAccountSwitch')));
//     // await tester.pump();

//     // Verify if the switch is toggled
//     // Switch switchWidget = tester.widget(find.byKey(Key('privateAccountSwitch')));
//     // expect(switchWidget.value, isTrue);
//   });

//   testWidgets('Save button is present and functional', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

//     // Verify if the Save Changes button is present
//     expect(find.byKey(Key('saveButton')), findsOneWidget);

//     // Tap the Save Changes button
//     await tester.tap(find.byKey(Key('saveButton')));
//     await tester.pump();

//     // Verify if the form save logic is triggered
//     // Add a mock or a print statement in the save logic to verify this
//   });


// }
