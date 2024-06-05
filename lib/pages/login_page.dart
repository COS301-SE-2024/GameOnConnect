// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/services/auth_service.dart';

class Login extends StatefulWidget {
  // ignore: use_super_parameters
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Controllers to control text
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/icons/Logo_dark.png'
                        : 'assets/icons/Logo_light.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  //Here is the login text
                  const Text(
                    'Login',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28.46200180053711),
                  ),
                  //Here is the email text field
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Padding(
                      padding: EdgeInsets.only(left: 0.0),
                      child: TextFormField(
                        key: Key('emailInput'),
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey[100],
                          filled: true,
                          contentPadding: EdgeInsets.only(left: 15, top: 12.5),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 190, 190, 190),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 216, 50),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            size: 20,
                          ),
                        ),
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
                  const SizedBox(height: 15),
                  //Here is the password text field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Padding(
                      padding: EdgeInsets.only(left: 0.0),
                      child: TextFormField(
                        key: Key('passwordInput'),
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey[100],
                          filled: true,
                          contentPadding: EdgeInsets.only(left: 15, top: 12.5),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 190, 190, 190),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 216, 50),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (!RegExp(r'^.{8,}$').hasMatch(value)) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!RegExp(r'^.*[A-Z].*$').hasMatch(value)) {
                            return 'Password must contain an uppercase letter';
                          }
                          if (!RegExp(r'^.*[!@#$%^&*(),.?":{}|<>].*$')
                              .hasMatch(value)) {
                            return 'Password must contain a symbol';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft, // Add this line
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 128, 216, 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  //The Login button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          signIn();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        key: Key('Login_Button'),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 128, 216, 50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Color.fromARGB(255, 24, 24, 24),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Expanded(
                        child: Divider(
                            color: Color.fromARGB(255, 190, 190, 190),
                            height: 40,
                            indent: 25,
                            endIndent: 10),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1),
                        child: Text("or"),
                      ),
                      Expanded(
                        child: Divider(
                            color: Color.fromARGB(255, 190, 190, 190),
                            height: 40,
                            indent: 10,
                            endIndent: 25),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        AuthService().signInWithGoogle();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        key: Key('Google_Login'),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 190, 190, 190),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 24, 24, 24),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        AuthService().signInWithGoogle();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        key: Key('Apple_Login'),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 190, 190, 190),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.apple,
                                size: 25,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Continue with Apple',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 24, 24, 24),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  //here is the bottom text with a sign up text
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' Sign Up',
                        style: TextStyle(
                            color: Color.fromARGB(255, 128, 216, 50),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
