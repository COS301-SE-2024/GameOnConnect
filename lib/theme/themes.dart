import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.yellow[300] ?? Colors.red,
      primary: Colors.amber[300] ?? Colors.amber,
    )
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
);
