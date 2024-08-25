import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';
import 'package:gameonconnect/view/theme/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../globals.dart' as globals;

class CustomizeService{
  //BuildContext get context => null;


  bool isCurrentlyDarkMode(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.dark;
}

Future<List<String>> fetchGenresFromAPI(bool isMounted) async {
    try {
      var url =
          Uri.parse('https://api.rawg.io/api/genres?key=${globals.apiKey}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        if (isMounted) {
          return (decoded['results'] as List)
                .map((genre) => genre['name'].toString())
                .toList();
        }
        else{
          return [];
        }

      } else {
        //print("Error fetching genres: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      //print("Error fetching genres: $e");
    }
    return [];
  }

  Future<List<String>> fetchTagsFromAPI(bool isMounted) async {
    try {
      if (isMounted) {
        var url =
            Uri.parse('https://api.rawg.io/api/tags?key=${globals.apiKey}');
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var decoded = json.decode(response.body);
          return (decoded['results'] as List)
                .map((tag) => tag['name'].toString())
                .toList();
        } else {
          return [];
        }
      }
      else{
        return [];
      }
    } catch (e) {
      //throw ("Error fetching interest tags: $e");
    }
    return [];
  }

  Future<List<List<String>>> fetchUserSelectionsFromDatabase() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        final db = FirebaseFirestore.instance;
        final profileDocRef =
            db.collection("profile_data").doc(currentUser.uid);

        final docSnapshot = await profileDocRef.get();
        if (docSnapshot.exists) {
          List<List<String>> customizeData=[];
          final data = docSnapshot.data();
          final genres = List<String>.from(data?["genre_interests_tags"] ?? []);
          final age = List<String>.from(data?["age_rating_tags"] ?? []);
          final interests =
              List<String>.from(data?["social_interests_tags"] ?? []);

          StorageService storageService = StorageService();
          String bannerDownloadUrl =
              await storageService.getBannerUrl(currentUser.uid);
          String profileDownloadUrl =
              await storageService.getProfilePictureUrl(currentUser.uid);

          List<String> pictures = [];
          pictures.add(bannerDownloadUrl);
          pictures.add(profileDownloadUrl);

          customizeData.add(genres);
          customizeData.add(age);
          customizeData.add(interests);
          customizeData.add(pictures);

          
          /*if (_isMounted) {
            setState(() {
              _selectedGenres = genres;
              _selectedAge = age;
              _selectedInterests = interests;
              _profileBannerUrl = bannerDownloadUrl;
              _profileImageUrl = profileDownloadUrl;
            });
          }*/
          return customizeData;
        }
        else{
          return [];
        }
      }else{
        return [];
      }
    } catch (e) {
      //throw ("Error fetching user selections: $e");
    }
    return [];
  }

  int getCurrentIndex(Color color)
   {
    if(color== darkPrimaryGreen || color== lightPrimaryGreen)
    {
      return 0;
    }
     if(color== darkPrimaryPurple || color== lightPrimaryPurple)
    {
      return 1;
    }
     if(color== darkPrimaryBlue || color== lightPrimaryBlue)
    {
      return 2; 
    }
     if(color== darkPrimaryOrange || color== lightPrimaryOrange)
    {
      return 3; 
    }
    if(color== darkPrimaryPink || color== lightPrimaryPink){
      return 4;
    }
    return -1;
  }

  void updateTheme(Color color, ThemeProvider themeProvider, bool isDarkMode) {

    if (color == darkPrimaryGreen) {
      themeProvider.setTheme(isDarkMode ? darkGreenTheme : lightGreenTheme);
    } else if (color == darkPrimaryPurple) {
      themeProvider.setTheme(isDarkMode ? darkPurpleTheme : lightPurpleTheme);
    } else if (color == darkPrimaryBlue) {
      themeProvider.setTheme(isDarkMode ? darkBlueTheme : lightBlueTheme);
    } else if (color == darkPrimaryOrange) {
      themeProvider.setTheme(isDarkMode ? darkOrangeTheme : lightOrangeTheme);
    } else if (color == darkPrimaryPink) {
      themeProvider.setTheme(isDarkMode ? darkPinkTheme : lightPinkTheme);
    }
  }

}