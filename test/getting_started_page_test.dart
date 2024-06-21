import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/getting_started_page.dart';

void main() {
  group('Getting started UI Tests', () {
    testWidgets('getting started UI loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GettingStarted()));
      await tester.pumpAndSettle();
      await tester.pump();

      expect(find.byKey(const Key('game_library_section'),), findsOneWidget);
      expect(find.byKey(const Key('Friends_section'),), findsOneWidget);
      expect(find.byKey(const Key('getting_started'),), findsOneWidget);
      expect(find.byKey(const Key('game_information_section'),), findsOneWidget);
      
    });
  });
}