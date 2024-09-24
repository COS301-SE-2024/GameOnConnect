import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/cache_managers/filtering_cache_manager.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';
import 'package:gameonconnect/view/theme/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../globals.dart' as globals;

class CustomizeService {
  //BuildContext get context => null;

  bool isCurrentlyDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  Future<List<String>> fetchGenresFromAPI(bool isMounted) async {
    String request = 'https://api.rawg.io/api/genres?key=${globals.apiKey}';

    var fileInfo = await FilteringCacheManager().getFileFromCache(request);

    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
      //Load the games from cache
      final jsonData = jsonDecode(await fileInfo.file.readAsString());

      if (isMounted) {
        List<String> genres = (jsonData['results'] as List)
            .map((genre) => genre['name'].toString())
            .toList();
        genres.sort();
        return genres;
      } else {
        return [];
      }
    } else {
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        //Cache data
        await FilteringCacheManager().putFile(
          request,
          response.bodyBytes,
          fileExtension: 'json',
        );
        final jsonData = jsonDecode(response.body);
        if (isMounted) {
          List<String> genres = (jsonData['results'] as List)
              .map((genre) => genre['name'].toString())
              .toList();
          genres.sort();
          return genres;
        } else {
          return [];
        }
      } else {
        return [];
      }
    }
  }

  Future<List<String>> fetchTagsFromAPI(bool isMounted) async {
    String request = 'https://api.rawg.io/api/tags?key=${globals.apiKey}';

    var fileInfo = await FilteringCacheManager().getFileFromCache(request);

    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
      //Load the games from cache
      final jsonData = jsonDecode(await fileInfo.file.readAsString());

      if (isMounted) {
        List<String> tags = (jsonData['results'] as List)
            .map((tag) => tag['name'].toString())
            .toList();
        tags.sort();
        return tags;
      } else {
        return [];
      }
    } else {
      //Load the games from API
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        //Cache data
        await FilteringCacheManager().putFile(
          request,
          response.bodyBytes,
          fileExtension: 'json',
        );
        final jsonData = jsonDecode(response.body);
        if (isMounted) {
          List<String> tags = (jsonData['results'] as List)
              .map((tag) => tag['name'].toString())
              .toList();
          tags.sort();
          return tags;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load tags');
      }
    }
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
          List<List<String>> customizeData = [];
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
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      //throw ("Error fetching user selections: $e");
    }
    return [];
  }

  int getCurrentIndex(Color color) {
    if (color == darkPrimaryGreen || color == lightPrimaryGreen) {
      return 0;
    }
    if (color == darkPrimaryPurple || color == lightPrimaryPurple) {
      return 1;
    }
    if (color == darkPrimaryBlue || color == lightPrimaryBlue) {
      return 2;
    }
    if (color == darkPrimaryOrange || color == lightPrimaryOrange) {
      return 3;
    }
    if (color == darkPrimaryPink || color == lightPrimaryPink) {
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

  Future<String> uploadImageToFirebase(File image, String imagetype) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Create a reference to Firebase Storage
    if (imagetype == 'Profile_picture') {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } else {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('banners/$uid.jpg');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("profile_data")
          .doc(uid)
          .update({
        'banner': downloadURL,
      });
      return downloadURL;
    }
  }

  Future<void> saveImageURL(String url, String imageType) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (imageType == 'Profile_picture') {
      await FirebaseFirestore.instance
          .collection("profile_data")
          .doc(uid)
          .update({
        'profile_picture': url,
      });
    } else {
      await FirebaseFirestore.instance
          .collection("profile_data")
          .doc(uid)
          .update({
        'banner': url,
      });
    }
  }

  Future<bool> saveProfileData(

      List<String> selectedGenres,
      List<String> selectedAge,
      List<String> selectedInterests) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        final db = FirebaseFirestore.instance;
        final profileDocRef =
            db.collection("profile_data").doc(currentUser.uid);
        final data = {
          "genre_interests_tags":
              selectedGenres.isNotEmpty ? selectedGenres : FieldValue.delete(),
          "age_rating_tags":
              selectedAge.isNotEmpty ? selectedAge : FieldValue.delete(),
          "social_interests_tags": selectedInterests.isNotEmpty
              ? selectedInterests
              : FieldValue.delete(),
        };

        await profileDocRef.set(data, SetOptions(merge: true));

        return true;
      }
    } catch (e) {
      //print ("Error setting/updating profile data: $e");
      return false;
    }
    return false;
  }
}
