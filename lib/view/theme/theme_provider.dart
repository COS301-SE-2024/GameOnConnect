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
  
  void setLightMode() {
    themeData = lightGreenTheme;
    _saveThemePreference('light');
  }

  void setDarkMode() {
    themeData = darkGreenTheme;
    _saveThemePreference('dark');
  }

  void toggleTheme() {
    if (_themeData == lightGreenTheme) {
      setDarkMode();
    } else {
      setLightMode();
    }
  }

  Future<void> _saveThemePreference(String theme) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection('profile_data').doc(user.uid).update({'theme': theme});
    }
  }

}