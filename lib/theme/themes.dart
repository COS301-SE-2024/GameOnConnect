import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.grey[500]!, // Use a grey color as the seed
    brightness: Brightness.light,
  ),
);


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple[700]!, // Use a deep purple color as the seed
    brightness: Brightness.dark,
  ),
);
