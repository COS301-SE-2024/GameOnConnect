import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color.fromRGBO(24, 24, 24, 1.0),
    primary: Color.fromRGBO(0, 255, 117, 1.0),
    secondary: Color.fromRGBO(190, 190, 190, 1.0),
    tertiary: Color.fromRGBO(136, 255, 131, 1.0),
    primaryContainer: Color.fromRGBO(42, 42, 42, 1.0)
  )
);

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color.fromRGBO(255, 255, 255, 1),
    primary: Color.fromRGBO(0, 185, 86, 1),
    secondary: Color.fromRGBO(42, 42, 42, 1.0),
    tertiary: Color.fromRGBO(136, 255, 131, 1.0),
    primaryContainer: Color.fromRGBO(244, 244, 244, 1.0)
  )
);
