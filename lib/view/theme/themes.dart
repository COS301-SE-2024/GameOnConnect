import 'package:flutter/material.dart';

//const Color primaryPurple = Color.fromRGBO(173, 0, 255, 1.0); //possible idea to extract the colors to easily maintain code is to extract colors here
const lightPrimaryContainer = Color.fromRGBO(232, 232, 232, 1.0);

ThemeData darkGreenTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: Color.fromRGBO(24, 24, 24, 1.0),
  primary: Color.fromRGBO(0, 255, 117, 1.0),
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(136, 255, 131, 1.0),
  primaryContainer: Color.fromRGBO(42, 42, 42, 1.0),
  onPrimary: Color.fromRGBO(0, 144, 66, 1.0),
));

ThemeData lightGreenTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: Color.fromRGBO(255, 255, 255, 1),
  primary: Color.fromRGBO(0, 185, 86, 1),
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(136, 255, 131, 1.0),
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(136, 255, 191, 1.0),
));

ThemeData darkPurpleTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: Color.fromRGBO(24, 24, 24, 1.0),
  primary: Color.fromRGBO(171, 140, 243, 1),
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(201, 84, 255, 1), //note this should be checked
  primaryContainer: Color.fromRGBO(42, 42, 42, 1.0),
  onPrimary: Color.fromRGBO(66,0,128, 1.0),
));

ThemeData lightPurpleTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: Color.fromRGBO(255, 255, 255, 1),
  primary: Color.fromRGBO(174, 87, 255, 1.0),
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(201, 84, 255, 1), //note this should be checked
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(213, 168, 255, 1.0),
));

ThemeData darkBlueTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: Color.fromRGBO(24, 24, 24, 1.0),
  primary: Color.fromRGBO(0, 10, 255, 1.0),
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(0, 217, 255, 1), //note this should be checked
  primaryContainer: Color.fromRGBO(42, 42, 42, 1.0),
  onPrimary: Color.fromRGBO(0, 144, 66, 1.0),
));

ThemeData lightBlueTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: Color.fromRGBO(255, 255, 255, 1),
  primary: Color.fromRGBO(0, 10, 255, 1.0),
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(0, 217, 255, 1), //note this should be checked
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(136, 255, 191, 1.0),
));

ThemeData darkYellowTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: Color.fromRGBO(24, 24, 24, 1.0),
  primary: Color.fromRGBO(235, 255, 0, 1.0),
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(242, 255, 102, 1), //note this should be checked
  primaryContainer: Color.fromRGBO(42, 42, 42, 1.0),
  onPrimary: Color.fromRGBO(0, 144, 66, 1.0),
));

ThemeData lightYellowTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: Color.fromRGBO(255, 255, 255, 1),
  primary: Color.fromRGBO(235, 255, 0, 1.0),
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(242, 255, 102, 1), //note this should be checked
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(136, 255, 191, 1.0),
));

ThemeData darkPinkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: Color.fromRGBO(24, 24, 24, 1.0),
  primary: Color.fromRGBO(249, 159, 199, 1.0),
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(255, 100, 221, 1), //note this should be checked
  primaryContainer: Color.fromRGBO(42, 42, 42, 1.0),
  onPrimary: Color.fromRGBO(175, 40, 87, 1.0),
));

ThemeData lightPinkTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: Color.fromRGBO(255, 255, 255, 1),
  primary: Color.fromRGBO(204, 0, 160, 1.0),
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(255, 100, 221, 1), //note this should be checked
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(225, 122, 158, 1.0),
));
