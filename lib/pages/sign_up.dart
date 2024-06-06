// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';
import 'home_page.dart';


const double _textFieldWidth = 300;
const InputDecoration _inputDecoration = InputDecoration(
  border: OutlineInputBorder(),
);
int? _nextNum;
Future<void> getNextNumber() async {

  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference profileRef = db.collection("next_digit");
  DocumentSnapshot qs = await profileRef.doc("current_max_digit").get();

  if(qs.exists) {
    Map<String,dynamic> d = qs.data() as Map<String,dynamic>;
    _nextNum = d['digit'];
  }
  int da = _nextNum ?? 0;
  db.collection("next_digit").doc("current_max_digit").update({"digit":(da+1)});


}

Future<void> createDefaultProfile() async
{
  try{

    FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    if(currentUser != null) {
      final defaultData = <String, dynamic>{
        "name": "",
        "surname": "",
        "age_rating_tags": [],
        "birthday": null,
        "genre_interests_tags": [],
        "profile_picture": "gs://gameonconnect-cf66d.appspot.com/default_image.jpg",
        "social_interests_tags": [],
        "theme": "light",
        "userID":  currentUser.uid,
        "username": {"profile_name": _username, "unique_num": _nextNum},
        "visibility": true,
        "banner" : "gs://gameonconnect-cf66d.appspot.com/default_banner.jpg"
      };

      db.collection("profile_data")
          .doc(currentUser.uid)
          .set(defaultData);
    }

  }catch(e)
  { // do nothing
  }

}
String? _username ;

class SignUp extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignUp({super.key});

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    await getNextNumber();
    await createDefaultProfile();

  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logo_dev, size: 100),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("Sign Up",
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: _textFieldWidth,
                        child: TextFormField(
                          key: Key('usernameInput'),
                          controller: _usernameController,
                          decoration:
                              _inputDecoration.copyWith(labelText: 'Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: _textFieldWidth,
                        child: TextFormField(
                          key: Key('emailInput'),
                          controller: _emailController,
                          decoration:
                              _inputDecoration.copyWith(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: _textFieldWidth,
                        child: TextFormField(
                          key: Key('passwordInput'),
                          controller: _passwordController,
                          obscureText: true,
                          decoration:
                              _inputDecoration.copyWith(labelText: 'Password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (!RegExp(
                                    r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
                                .hasMatch(value)) {
                              return 'Password must contain an uppercase letter, a symbol and at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: _textFieldWidth,
                        child: TextFormField(
                          key: Key('confirmPasswordInput'),
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: _inputDecoration.copyWith(
                              labelText: 'Confirm Password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: _textFieldWidth,
                height: 50,
                child: FilledButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.purple)),
                  onPressed: () {
                    // Validate and process the form.
                    if (_formKey.currentState!.validate()) {
                      _username = _usernameController.text;
                      signUp();
                      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(title: 'GameOnConnect',)),
                            (Route<dynamic> route) => false,
                      );

                    }
                  },
                  child: const Text(
                    key: Key('signUpButton'),
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  InkWell(
                    onTap: () {Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
                      (Route<dynamic> route) => false,
                    );  },

                    child: Text(' Login',
                      style: TextStyle(color: Color.fromARGB(255, 214, 193, 4),
                          fontWeight: FontWeight.bold
                      ),
                    )
                  )
                  ],
              )
            ],
        )
          ),
        ),
      );
  }
}
