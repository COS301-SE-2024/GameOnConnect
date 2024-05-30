import 'package:flutter/material.dart';
import 'package:gameonconnect/theme/themes.dart';

class ThemeProvider with ChangeNotifier{

  ThemeData _themeData = lightTheme;

  // ignore: unnecessary_getters_setters
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      themeData = darkTheme; 
    } else {
      themeData = lightTheme;
    }
  }

}