import 'package:flutter/material.dart';

const double _textFieldWidth = 300;
const InputDecoration _inputDecoration = InputDecoration(
  border: OutlineInputBorder(),
);

class SignUp extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: _textFieldWidth,
                      child: TextField(
                        controller: _usernameController,
                        decoration:
                            _inputDecoration.copyWith(labelText: 'Username'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: _textFieldWidth,
                      child: TextField(
                        controller: _emailController,
                        decoration:
                            _inputDecoration.copyWith(labelText: 'Email'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: _textFieldWidth,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration:
                            _inputDecoration.copyWith(labelText: 'Password'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: _textFieldWidth,
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: _inputDecoration.copyWith(
                            labelText: 'Confirm Password'),
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
                onPressed: () {
                  // Validate and process the form.
                  print("signup");
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
