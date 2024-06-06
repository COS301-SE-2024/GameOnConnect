import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  signInWithGoogle() async {
    //start the sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //get the authentication details
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //make a new credential with the access token and the id token
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //sign in the user with the credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
