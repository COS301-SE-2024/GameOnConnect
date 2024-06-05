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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                  const SizedBox(height: 25),
                  //Here is the welcome text
                  const Text(
                    'Welcome to GameOnConnect!',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 25),
                  //Here is the email text field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          key: Key('emailInput'),
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
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
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          key: Key('passwordInput'),
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                          ),
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
                  ),
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
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
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
                        ' Create Now',
                        style: TextStyle(
                            color: Color.fromARGB(255, 214, 193, 4),
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
