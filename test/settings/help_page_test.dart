import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/view/pages/settings/getting_started.dart';

void main() {
  group('Help Page UI Tests', () {
    testWidgets('Help page should have a back button and display "Getting started"', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GettingStarted()));

      expect(find.byKey(const Key('Back_button_key'),), findsOneWidget);
      expect(find.byKey(const Key('Help_text'),), findsOneWidget);
      
    });

  });
}