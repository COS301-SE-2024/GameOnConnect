import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/pages/events/choose_my_games_page.dart';

void main() {
  group('Choose games Widget Tests', () {
    testWidgets('AppBar and button Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChooseGame(
            chosenGame: 4291,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BackButtonAppBar), findsOneWidget);
      expect(find.byKey(const Key('Back_button_key'),), findsOneWidget);
      expect(find.byKey(const Key('select_a_game_text'),), findsOneWidget);
      expect(find.byKey(const Key('save_game_button'),), findsOneWidget);
      expect(find.byKey(const Key('save_game_text'),), findsOneWidget);
    });
  });
}
