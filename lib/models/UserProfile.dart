import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String username;
  //final String profilePictureUrl;
  final bool isFollowing;
  final String uid;

 UserProfile({required this.username,required this.uid,required this.isFollowing});

//extract necesary info from snapshot
factory UserProfile.fromDocumentSnapshot(DocumentSnapshot doc) {
  Map<String, dynamic> usernameMap = doc['username'];
  return UserProfile(
    username: usernameMap['profile_name'],
    uid: doc['userID'],
    isFollowing: false, // This will be updated based on whether the user is following or not
  );
}

}