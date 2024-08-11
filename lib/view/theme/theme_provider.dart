import 'package:flutter/material.dart';
import 'package:gameonconnect/view/theme/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThemeProvider with ChangeNotifier{

  ThemeData _themeData = darkGreenTheme;

  // ignore: unnecessary_getters_setters
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
    _saveThemePreference(_getTheme(theme));
  }
  
  void setLightGreenMode() {
    themeData = lightGreenTheme;
    _saveThemePreference('light_green');
  }

  void setDarkGreenMode() {
    themeData = darkGreenTheme;
    _saveThemePreference('dark_green');
  }

  void setLightPurpleMode() {
    themeData = lightPurpleTheme;
    _saveThemePreference('light_purple');
  }

  void setDarkPurpleMode() {
    themeData = darkPurpleTheme;
    _saveThemePreference('dark_purple');
  }

  void setLightBlueMode() {
    themeData = lightBlueTheme;
    _saveThemePreference('light_blue');
  }

  void setDarkBlueMode() {
    themeData = darkBlueTheme;
    _saveThemePreference('dark_blue');
  }

  void setLightYellowMode() {
    themeData = lightYellowTheme;
    _saveThemePreference('light_yellow');
  }

  void setDarkYellowMode() {
    themeData = darkYellowTheme;
    _saveThemePreference('dark_yellow');
  }

  void setLightPinkMode() {
    themeData = lightPinkTheme;
    _saveThemePreference('light_pink');
  }

  void setDarkPinkMode() {
    themeData = darkPinkTheme;
    _saveThemePreference('dark_pink');
  }

  void toggleTheme() {
    if (_themeData == lightGreenTheme) {
      setDarkGreenMode();
    } else if (_themeData == darkGreenTheme) {
      setLightGreenMode();
    } else if (_themeData == lightPurpleTheme) {
      setDarkPurpleMode();
    } else if (_themeData == darkPurpleTheme) {
      setLightPurpleMode();
    } else if (_themeData == lightBlueTheme) {
      setDarkBlueMode();
    } else if (_themeData == darkBlueTheme) {
      setLightBlueMode();
    } else if (_themeData == lightYellowTheme) {
      setDarkYellowMode();
    } else if (_themeData == darkYellowTheme) {
      setLightYellowMode();
    } else if (_themeData == lightPinkTheme) {
      setDarkPinkMode();
    } else if (_themeData == darkPinkTheme) {
      setLightPinkMode();
    }
  }

  Future<void> _saveThemePreference(String theme) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection('profile_data').doc(user.uid).update({'theme': theme});
    }
  }

  String _getTheme(ThemeData theme) {
    if (theme == lightGreenTheme) return 'light_green';
    if (theme == darkGreenTheme) return 'dark_green';
    if (theme == lightPurpleTheme) return 'light_purple';
    if (theme == darkPurpleTheme) return 'dark_purple';
    if (theme == lightBlueTheme) return 'light_blue';
    if (theme == darkBlueTheme) return 'dark_blue';
    if (theme == lightYellowTheme) return 'light_yellow';
    if (theme == darkYellowTheme) return 'dark_yellow';
    if (theme == lightPinkTheme) return 'light_pink';
    if (theme == darkPinkTheme) return 'dark_pink';
    return 'unknown';
  }

}