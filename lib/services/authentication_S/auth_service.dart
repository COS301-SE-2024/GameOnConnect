import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  int? _nextNum;

  Future<void> getNextNumber() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference profileRef = db.collection("next_digit");
    DocumentSnapshot qs = await profileRef.doc("current_max_digit").get();

    if (qs.exists) {
      Map<String, dynamic> d = qs.data() as Map<String, dynamic>;
      _nextNum = d['digit'];
    }
    int da = _nextNum ?? 0;
    db
        .collection("next_digit")
        .doc("current_max_digit")
        .update({"digit": (da + 1)});
  }

  //getter function to return nextnum
  Future<int> getNextNum() async {
    await getNextNumber();
    return _nextNum ?? 0;
  }

  signInWithGoogle() async {
    //start the sign in process
    final GoogleSignIn googleSignIn = GoogleSignIn(
      signInOption: SignInOption.standard,
    );
    try {
      // Start the sign in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in process
        return null;
      }

      // Get the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Make a new credential with the access token and the id token
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (authResult.user != null) {
        // Check if the user already has a profile
        bool profileExists = await checkUserProfileExists(authResult.user!.uid);
        if (!profileExists) {
          // The account has been created, call the createDefaultProfile function
          createDefaultProfile("Default user");
        }
      }

      return authResult;
      //return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle errors here
      //print("Error signing in with Google: $e");
    }
    return null;
  }

  Future<bool> checkUserProfileExists(String userId) async {
    //Go to Firebase, see if there is a profile
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot profilesnapshot =
        await db.collection("profile_data").doc(userId).get();
    // Return true if exists, false otherwise
    if (profilesnapshot.exists) {
      //print('True'); use this print statement to see if the function gets called
      return true;
    } else {
      return false;
    }
  }

  Future<void> createDefaultProfile(String? username) async {
    try {
      await getNextNumber();
      FirebaseFirestore db = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final defaultData = <String, dynamic>{
          "age_rating_tags": [],
          "banner": dotenv.env['DEFAULT_BANNER_URL'],
          "bio": "",
          "birthday": Timestamp.now(),
          "profile_picture": dotenv.env['DEFAULT_IMAGE_URL'],
          "username": {"profile_name": username, "unique_num": _nextNum},
          "currently_playing": "",
          "my_games": [],
          "recent_activity": [],
          "genre_interests_tags": [],
          "social_interests_tags": [],
          "name": "",
          "surname": "",
          "theme": "light",
          "userID": currentUser.uid,
          "visibility": true,
          "want_to_play": [],
          "positions": [],
        };

        final connectionData = <String, dynamic>{
          "connection_requests": [],
          "connections": [],
          "pending": [],
          "userID": currentUser.uid
        };

        final badgeData = <String, dynamic>{
          "achiever_badge": {"date_unlocked": null, "unlocked": false},
          "collector_badge": {
            "count": 0,
            "date_unlocked": null,
            "unlocked": false
          },
          "customizer_badge": {
            "count": 0,
            "date_unlocked": null,
            "unlocked": false
          },
          "event_planner_badge": {"date_unlocked": null, "unlocked": false},
          "explorer_badge": {
            "changed_theme": false,
            "created_chat": false,
            "date_unlocked": null,
            "edit_profile": false,
            "join_event": false,
            "play_spaceshooter": false,
            "search_connection": false,
            "search_game": false,
            "share_game": false,
            "unlocked": false,
            "view_activity": false,
            "view_help": false,
            "view_requests": false,
            "view_stats": false,
            "want_to_play": false,
          },
          "gamer_badge": {"date_unlocked": null, "unlocked": false},
          "loyalty_badge": {
            "count": 0,
            "date_unlocked": null,
            "latest_date": Timestamp.now(),
            "unlocked": false
          },
          "newbie_badge": {"date_unlocked": Timestamp.now(), "unlocked": true},
          "nightowl_badge": {"date_unlocked": null, "unlocked": false},
          "social_butterfly_badge": {
            "count": 0,
            "date_unlocked": null,
            "unlocked": false
          },
          "userID": currentUser.uid,
        };

        db.collection("badges").doc(currentUser.uid).set(badgeData);
        db.collection("profile_data").doc(currentUser.uid).set(defaultData);
        db.collection("connections").doc(currentUser.uid).set(connectionData);
      }
    } catch (e) {
      //do nothing
    }
  }

  signInWithApple() async {
    // Request credentials
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'de.lunaone.flutter.signinwithappleexample.service',
        redirectUri: Uri.parse(
          'https://siwa-flutter-plugin.dev/', // Replace with your Return URL
        ),
      ),
    );

    // Create an `OAuthCredential` from the credential returned by Apple
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    // Sign in the user with Firebase
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
