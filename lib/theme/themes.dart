import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Inter',
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 128, 216, 50), 
    brightness: Brightness.light,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color.fromARGB(255, 128, 216, 50), 
    textTheme: ButtonTextTheme.primary,
  ),
 textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black, 
      backgroundColor: const Color.fromARGB(255, 128, 216, 50), 
    ),
  ),
);


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Inter',
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 128, 216, 50), 
    brightness: Brightness.dark,
  ),
);

