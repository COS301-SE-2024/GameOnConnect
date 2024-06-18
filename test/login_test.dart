import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/login_page.dart';

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  if (!RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
      .hasMatch(value)) {
    return 'Password must contain an uppercase letter, a symbol and at least 8 characters';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email address';
  }
  if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

void main() {
  group('Login Widget Tests', () {
    testWidgets('If Login Page loads render the correct UI', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Login()));
      //UI tests to see if the code is loaded
      expect(find.text('Login'), findsNWidgets(2)); 
      expect(find.text('Don\'t have an account? '), findsOneWidget);
      expect(find.text(' Sign Up'), findsOneWidget);
      expect(find.byKey(const Key('Login_Button')), findsOneWidget);
      expect(find.byKey(const Key('Google_Login')), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.byKey(const Key('emailInput')), findsOneWidget);
      expect(find.byKey(const Key('passwordInput')), findsOneWidget);
    });
  }); 

  group('Password Validator', () {
    test('returns error if password is null', () {
      expect(passwordValidator(null), 'Please enter a password');
    });

    test('returns error if password is empty', () {
      expect(passwordValidator(''), 'Please enter a password');
    });

    test('returns error if password is less than 8 characters', () {
      expect(passwordValidator('Ab1!'),
          'Password must contain an uppercase letter, a symbol and at least 8 characters');
    });

    test('returns error if password has no uppercase letter', () {
      expect(passwordValidator('abcdef!@#'),
          'Password must contain an uppercase letter, a symbol and at least 8 characters');
    });

    test('returns error if password has no symbol', () {
      expect(passwordValidator('Abcdefgh'),
          'Password must contain an uppercase letter, a symbol and at least 8 characters');
    });

    test('returns null if password is valid', () {
      expect(passwordValidator('Abcdef1!'), null);
    });
  });

  group('Email Validator', () {
    test('returns error if email is null', () {
      expect(emailValidator(null), 'Please enter an email address');
    });

    test('returns error if email is empty', () {
      expect(emailValidator(''), 'Please enter an email address');
    });

    test('returns error if email is invalid (missing @)', () {
      expect(emailValidator('invalidemail.com'),
          'Please enter a valid email address');
    });

    test('returns error if email is invalid (missing domain)', () {
      expect(emailValidator('invalid@'), 'Please enter a valid email address');
    });

    test('returns error if email is invalid (invalid domain)', () {
      expect(emailValidator('invalid@domain'),
          'Please enter a valid email address');
    });

    test('returns null if email is valid', () {
      expect(emailValidator('test@example.com'), null);
    });
  }); 
}

