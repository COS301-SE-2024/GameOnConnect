import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  group('Login Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets("Login Page Test", (tester) async {
      app.main();
      await tester.pumpAndSettle();

       await tester.pump(const Duration(seconds: 2));

      var emailField = find.byKey(const Key('emailInput'));
      var passwordField = find.byKey(const Key('passwordInput'));
      var loginButton = find.byKey(const Key('Login_Button'));

      //expect(emailField, findsOneWidget, reason: "Email input field not found");
      //expect(passwordField, findsOneWidget, reason: "Password input field not found");
      //expect(loginButton, findsOneWidget, reason: "Login button not found");
      
      // Enter text for the email address
      await tester.enterText(emailField, 'testuser@example.com');
      await Future.delayed(const Duration(seconds: 2));

      // Enter text for the password
      await tester.enterText(passwordField, 'Password1234\$');
      await Future.delayed(const Duration(seconds:3));

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
    });
  });
}