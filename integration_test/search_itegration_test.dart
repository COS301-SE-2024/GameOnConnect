import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'login_integration_test.dart';

void main() {
  group('Search Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets("Search Page Test", (tester) async {
      await login(tester);

      
    });
  });
}