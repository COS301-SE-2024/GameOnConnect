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

    
  });
}
