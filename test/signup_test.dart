import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/pages/sign_up.dart';

void main() {
  testWidgets('Test if the values of input fields when signing up', (WidgetTester tester) async {
    // Build the SignUp widget
    await tester.pumpWidget(MaterialApp(home: SignUp()));

    // Find the input fields and sign-up button
    final usernameField = find.byKey(const Key('usernameInput'));
    final emailField = find.byKey(const Key('emailInput'));
    final passwordField = find.byKey(const Key('passwordInput'));
    final confirmPasswordField = find.byKey(const Key('confirmPasswordInput'));
    final signUpButton = find.byKey(const Key('signUpButton'));

    // Enter text into the input fields
    await tester.enterText(usernameField, 'testuser');
    await tester.enterText(emailField, 'testuser@example.com');
    await tester.enterText(passwordField, 'Password123!');
    await tester.enterText(confirmPasswordField, 'Password123!');

    // Tap the sign-up button
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    // Verify the input field values
    expect(find.text('testuser'), findsOneWidget);
    expect(find.text('testuser@example.com'), findsOneWidget);
    expect(find.text('Password123!'), findsWidgets);
  });
}