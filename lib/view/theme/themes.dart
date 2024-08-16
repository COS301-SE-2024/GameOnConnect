import 'package:flutter/material.dart';

const lightPrimaryContainer = Color.fromRGBO(232, 232, 232, 1.0);
const darkPrimaryContainer = Color.fromRGBO(42, 42, 42, 1.0);
const darkPrimaryPurple = Color.fromRGBO(171, 140, 243, 1.0);
const darkPrimaryGreen = Color.fromRGBO(0, 255, 117, 1.0);
const darkPrimaryBlue = Color.fromRGBO(84, 235, 255, 1.0);
const darkPrimaryOrange = Color.fromRGBO(255, 184, 102, 1.0);
const darkPrimaryPink = Color.fromRGBO(249, 159, 199, 1.0);
const lightPrimaryGreen = Color.fromRGBO(0, 185, 86, 1);
const lightPrimaryPurple = Color.fromRGBO(174, 87, 255, 1.0);
const lightPrimaryBlue = Color.fromRGBO(77, 82, 255, 1.0);
const lightPrimaryOrange = Color.fromRGBO(218,118,0, 1.0);
const lightPrimaryPink = Color.fromRGBO(204, 0, 160, 1.0);
const darkSurface = Color.fromRGBO(24, 24, 24, 1.0);
const lightSurface = Color.fromRGBO(255, 255, 255, 1.0);

ThemeData darkGreenTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: darkSurface,
  primary: darkPrimaryGreen,
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(136, 255, 131, 1.0),
  primaryContainer: darkPrimaryContainer,
  onPrimary: Color.fromRGBO(0, 144, 66, 1.0),
));

ThemeData lightGreenTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: lightSurface,
  primary: lightPrimaryGreen,
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(136, 255, 131, 1.0),
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(136, 255, 191, 1.0),
));

ThemeData darkPurpleTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: darkSurface,
  primary: darkPrimaryPurple,
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(201, 84, 255, 1), //note this should be checked
  primaryContainer: darkPrimaryContainer,
  onPrimary: Color.fromRGBO(66, 0, 128, 1.0),
));

ThemeData lightPurpleTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: lightSurface,
  primary: lightPrimaryPurple,
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(201, 84, 255, 1), //note this should be checked
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(213, 168, 255, 1.0),
));

ThemeData darkBlueTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: darkSurface,
  primary: darkPrimaryBlue,
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(0, 217, 255, 1), //note this should be checked
  primaryContainer: darkPrimaryContainer,
  onPrimary: Color.fromRGBO(0, 6, 168, 1.0),
));

ThemeData lightBlueTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: lightSurface,
  primary: lightPrimaryBlue,
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(0, 217, 255, 1), //note this should be checked
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(179, 181, 255, 1.0),
));

ThemeData darkOrangeTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: darkSurface,
  primary: darkPrimaryOrange,
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(242, 255, 102, 1), //note this should be checked
  primaryContainer: darkPrimaryContainer,
  onPrimary: Color.fromRGBO(218,118,0, 0.7),
));

ThemeData lightOrangeTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: lightSurface,
  primary: lightPrimaryOrange,
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(242, 255, 102, 1), //note this should be checked
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(218,118,0, 0.5),
));

ThemeData darkPinkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  surface: darkSurface,
  primary: darkPrimaryPink,
  secondary: Color.fromRGBO(190, 190, 190, 1.0),
  tertiary: Color.fromRGBO(255, 100, 221, 1), //note this should be checked
  primaryContainer: darkPrimaryContainer,
  onPrimary: Color.fromRGBO(175, 40, 87, 1.0),
));

ThemeData lightPinkTheme = ThemeData(
    colorScheme: const ColorScheme.light(
  surface: lightSurface,
  primary: lightPrimaryPink,
  secondary: Color.fromRGBO(42, 42, 42, 1.0),
  tertiary: Color.fromRGBO(255, 100, 221, 1), //note this should be checked
  primaryContainer: lightPrimaryContainer,
  onPrimary: Color.fromRGBO(225, 122, 158, 1.0),
));
