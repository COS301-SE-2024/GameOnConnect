import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/profile_management_page.dart';

void main() {
  group('Profile Management Page UI Tests', () {
    testWidgets('Profile Management UI loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileManagement()));
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('back_button'),
        ),
        findsOneWidget);
        expect(
        find.byKey(
          const Key('Change_username'),
        ),
        findsOneWidget);
        expect(
        find.byKey(
          const Key('Change_first_name'),
        ),
        findsOneWidget);



    });
  });
}