import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/pages/profile_page.dart';

void main() {
  group('Profile Page UI Tests', () {
    testWidgets('Profile UI loads', (WidgetTester tester) async {

      await tester.pumpWidget(MaterialApp(home: Profile()));
      await tester.pumpAndSettle();


      await tester.pump(const Duration(seconds: 1));
      //expect(find.byKey(const Key('loadingScaffold'),), findsOneWidget);
      //expect(find.byKey(const Key('errorScaffold'),), findsOneWidget);
      expect(find.byKey(const Key('emptyDataScaffold'),), findsOneWidget);
      //expect(find.byKey(const Key('settings_icon_button')), findsOneWidget);

    });
  });
}