import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async{
    //start the sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //get the authentication details
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    //make a new credential with the access token and the id token
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //sign in the user with the credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}