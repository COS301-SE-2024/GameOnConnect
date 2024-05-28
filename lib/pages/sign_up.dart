import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

const double _textFieldWidth = 300;
const InputDecoration _inputDecoration = InputDecoration(
  border: OutlineInputBorder(),
);

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
                    signUp();
                  }
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const Text("Already have an account? Login")
          ],
        ),
      ),
    );
  }
}