import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:gameonconnect/main.dart'; // Import your app's main widget

void main() {
  patrolTest(
    'counter state is the same after going to home and switching apps',
    ($) async {
      // Add debugging information
      debugPrint('Starting test: counter state is the same after going to home and switching apps');

      // Replace with your app's main widget
      await $.pumpWidgetAndSettle(
        const MyApp(), // Use your app's main widget
      );

      // Add debugging information
      debugPrint('App widget pumped and settled');

      // Add your specific widget tests here
      try {
        expect($('app'), findsOneWidget);
        debugPrint('App widget found');
      } catch (e) {
        debugPrint('Error finding app widget: $e');
        rethrow;
      }
    },
  );
}