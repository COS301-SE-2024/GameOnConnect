import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/login_page.dart';

void main() {
  group('Login Widget Tests', () {

    testWidgets('If Login Page loads render the correct UI', (WidgetTester tester) async {
      //load Login widget
      await tester.pumpWidget(const MaterialApp(home: Login()));

      //UI tests to see if the code is loaded
      expect(find.text('Login'), findsNWidgets(2)); 
      expect(find.text('Don\'t have an account? '), findsOneWidget);
      expect(find.text(' Sign Up' ), findsOneWidget);
      expect(find.byKey(const Key('Login_Button')), findsOneWidget);
    });
  });
}

