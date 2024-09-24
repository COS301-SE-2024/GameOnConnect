

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'customize_service.dart';

class EditProfileService{

  Future<Map<String,dynamic>?> databaseAccess() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      CollectionReference profileRef = db.collection("profile_data");
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot qs = await profileRef.doc(currentUser.uid).get();
        if (qs.exists) {
          //access specific data :
          Map<String, dynamic> d = qs.data() as Map<String, dynamic>;
          return d;
        }
      }
    return null;
    } catch (e) {
    return null;
    }
  }


  Future<void> editProfile(String username, String firstname, String lastName,
      String bio, DateTime birthday, bool privacy, profileImage,
  profileBanner,) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        if (username.isNotEmpty) {
          final data = {"username.profile_name": username};
          await db.collection("profile_data").doc(currentUser.uid).update(
              data);
        }
        if (firstname.isNotEmpty) {
          final data = {"name": firstname};
          await db.collection("profile_data").doc(currentUser.uid).update(
              data);
        }
        if (lastName.isNotEmpty) {
          final data = {"surname": lastName};
          await db.collection("profile_data").doc(currentUser.uid).update(
              data);
        }
        if (bio.isNotEmpty) {
          final data = {"bio": bio};
          await db.collection("profile_data").doc(currentUser.uid).update(
              data);
        }
        final data = {"birthday": birthday, "visibility": privacy};

        await db.collection("profile_data").doc(currentUser.uid).update(data);
        if (profileImage != null) {
          String imageUrl;
          if (kIsWeb) {
            imageUrl = await CustomizeService()
                .uploadImageToFirebase(File(profileImage!), 'Profile_picture');
          } else {
            imageUrl = await CustomizeService()
                .uploadImageToFirebase(File(profileImage!), 'Profile_picture');
          }
          await CustomizeService().saveImageURL(imageUrl, 'Profile_picture');
        }
          if (profileBanner != null) {
            String bannerUrl;
            if (kIsWeb) {
              bannerUrl = await CustomizeService()
                  .uploadImageToFirebase(File(profileBanner!), 'banner');
            } else {
              bannerUrl = await CustomizeService()
                  .uploadImageToFirebase(File(profileBanner!), 'banner');
            }
            await CustomizeService().saveImageURL(bannerUrl, 'banner');


          }
        }

    } catch (e) {
      // ignore: use_build_context_synchronously

      throw Exception('Error updating profile: $e');
    }
  }

}