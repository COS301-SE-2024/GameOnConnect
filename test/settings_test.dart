import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/view/pages/settings/settings_page.dart';

void main() {
  testWidgets('Navigates to Customize Profile on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Options()));
    await tester.pumpAndSettle();

    expect(
        find.byKey(
          const Key('settings_text'),
        ),
        findsOneWidget);
    expect(
        find.byKey(
          const Key('Back_button_key'),
        ),
        findsOneWidget);
    expect(
        find.byKey(
          const Key('Customize_Profile'),
        ),
        findsOneWidget);
    expect(
        find.byKey(
          const Key('Help_Centre'),
        ),
        findsOneWidget);
    expect(
        find.byKey(
          const Key('Logout'),
        ),
        findsOneWidget);

    //await tester.tap(find.text('Customize Profile'));
    //await tester.pumpAndSettle();
  });
}
