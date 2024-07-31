import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../globals.dart' as globals;

import 'package:http/http.dart' as http;

import '../profile_S/storage_service.dart';


class CustomizeService{
  Future<List<String>> fetchGenresFromAPI() async {
    try {
      var url =
      Uri.parse('https://api.rawg.io/api/genres?key=${globals.apiKey}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
          return (decoded['results'] as List)
              .map((genre) => genre['name'].toString())
              .toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> fetchTagsFromAPI() async {
    try {
      var url = Uri.parse('https://api.rawg.io/api/tags?key=${globals.apiKey}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        return (decoded['results'] as List)
              .map((tag) => tag['name'].toString())
              .toList();

      } else {
        throw ("Error fetching interest tags: ${response.statusCode}");
      }
    } catch (e) {
      throw ("Error fetching interest tags: $e");
    }
  }

  Future<Map<String,dynamic>> fetchUserSelectionsFromDatabase() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        final db = FirebaseFirestore.instance;
        final profileDocRef =
        db.collection("profile_data").doc(currentUser.uid);

        final docSnapshot = await profileDocRef.get();
        if (docSnapshot.exists) {
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

          return{
            'genres' : genres,
            'age' :age,
            'interests':interests,
            'bannerUrl': bannerDownloadUrl,
            'profileUrl': profileDownloadUrl
          };

        }
        throw ("No data to show");
      }
      throw ("No data to show");

    } catch (e) {
      throw ("Error fetching user selections: $e");
    }
  }

}