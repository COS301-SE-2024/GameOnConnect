import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  String? _username;
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
        // The account has been created, call the createDefaultProfile function
        createDefaultProfile(authResult.user!.uid);
      }

      return authResult;
      //return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle errors here
      //print("Error signing in with Google: $e");
    }
    return null;
  }

  void createDefaultProfile(String uid) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final defaultData = <String, dynamic>{
        "name": "",
        "surname": "",
        "age_rating_tags": [],
        "birthday": null,
        "genre_interests_tags": [],
        "profile_picture":
            "gs://gameonconnect-cf66d.appspot.com/default_image.jpg",
        "social_interests_tags": [],
        "theme": "light",
        "userID": currentUser.uid,
        "username": {"profile_name": _username, "unique_num": _nextNum},
        "visibility": true,
        "banner": "gs://gameonconnect-cf66d.appspot.com/default_banner.jpg"
      };

      db.collection("profile_data").doc(currentUser.uid).set(defaultData);
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
}
