// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  //Here is the icon
                  const Icon(
                    Icons.logo_dev,
                    size: 100,
                  ),
                  const SizedBox(height: 25),
                  //Here is the login text
                  const Text(
                    'Login',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28.46200180053711),
                  ),
                  //Here is the email text field
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(
                              color: Color.fromARGB(255, 190, 190, 190)),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: TextFormField(
                          key: Key('emailInput'),
                          controller: emailController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15, top: 12.5),
                            border: InputBorder.none,
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
                  ),
                  const SizedBox(height: 20),
                  //Here is the password text field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(
                              color: Color.fromARGB(255, 190, 190, 190)),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: TextFormField(
                          key: Key('passwordInput'),
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15, top: 12.5),
                            border: InputBorder.none,
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
                  ),
                  const SizedBox(height: 15),
                  Text("Forgot password?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 128, 216, 50),
                      )),
                  const SizedBox(height: 30),
                  //The Login button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          signIn();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
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
                  const SizedBox(height: 20),
                  //here is the bottom text with a create now text
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
