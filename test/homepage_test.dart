import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/home_page.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('HomePage builds without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage(title: 'Test Home')));
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Icons loading', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage(title: 'Test Home')));

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.home_filled), findsOneWidget);
      expect(find.byIcon(Icons.gamepad_rounded), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}