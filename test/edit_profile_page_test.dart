import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/edit_profile_page.dart'; // Adjust to your package name

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
}
