// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';
import 'package:gameonconnect/view/pages/home/welcome_splash.dart';
import '../../../services/authentication_S/auth_service.dart';
import 'login_page.dart';


class SignUp extends StatefulWidget {
  // ignore: use_super_parameters
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserCredential? _userG;
  String? _username;

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    await AuthService().getNextNumber();
    await AuthService().createDefaultProfile(_username);

  }
  Future google() async{
    _userG = await AuthService().signInWithGoogle();
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/icons/GameOnConnect_Logo_Transparent_White.png'
                    : 'assets/icons/GameOnConnect_Logo_Transparent.png',
                width: 100.pixelScale(context),
                height: 100.pixelScale(context),
              ),
               Padding(
                padding: EdgeInsets.all(20.pixelScale(context)),
                child: Text("Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28.46200180053711.pixelScale(context)
                    )),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 25.0.pixelScale(context)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: TextFormField(
                          key: Key('emailInput'),
                          controller: _emailController,
                          decoration:InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15.pixelScale(context), top: 12.5.pixelScale(context)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(15.pixelScale(context)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15.pixelScale(context)),
                            ),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              size: 20.pixelScale(context),
                            ),
                            hintStyle: TextStyle(fontSize: 16.pixelScale(context)),
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
                     SizedBox(height: 15.pixelScale(context)),

                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 25.0.pixelScale(context)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: TextFormField(
                          key: Key('usernameInput'),
                          controller: _usernameController,
                          decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15.pixelScale(context), top: 12.5.pixelScale(context)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(15.pixelScale(context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15.pixelScale(context)),
                          ),
                          hintText: 'Username',
                          hintStyle: TextStyle(fontSize: 16.pixelScale(context)),
                          prefixIcon: Icon(
                            Icons.person,
                            size: 20.pixelScale(context),
                          ),
                          ),                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                     SizedBox(height: 15.pixelScale(context)),

                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 25.0.pixelScale(context)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: TextFormField(
                          key: Key('passwordInput'),
                          controller: _passwordController,
                          obscureText: true,
                          decoration:InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15.pixelScale(context), top: 12.5.pixelScale(context)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(15.pixelScale(context)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15.pixelScale(context)),
                            ),
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 20.pixelScale(context),
                            ),
                            hintStyle: TextStyle(fontSize: 16.pixelScale(context)),
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
                    /*Padding(
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
                    ),*/
                  ],
                ),
              ),
               SizedBox(height: 20.pixelScale(context)),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 25.0.pixelScale(context)),
                child: GestureDetector(
                  onTap: () {

                      if (_formKey.currentState!.validate()) {
                        _username = _usernameController.text;
                        signUp();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Signed Up successfully!")));
                        Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                            builder: (BuildContext context) => SplashScreen()),
                              (Route<dynamic> route) => false,
                        );
                      }

                  },
                  child: Container(
                    padding: EdgeInsets.all(15.pixelScale(context)),
                    key: Key('signupButton'),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 255, 117),
                      borderRadius: BorderRadius.circular(15.pixelScale(context)),
                    ),
                    child:  Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color.fromARGB(255, 24, 24, 24),
                          fontWeight: FontWeight.w700,
                          fontSize: 15.pixelScale(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
               SizedBox(height: 25.pixelScale(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  Expanded(
                    child: Divider(
                        color: Color.fromARGB(255, 190, 190, 190),
                        height: 40,
                        indent: 25,
                        endIndent: 10),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.pixelScale(context)),
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
               SizedBox(height: 25.pixelScale(context)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0.pixelScale(context)),
                child: GestureDetector(
                  onTap:  ()  {
                    google();
                    if (_userG != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SplashScreen()),
                            (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    key: Key('Google_Login'),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 190, 190, 190),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:  Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.google,
                            size: 20,
                            color: Colors.black
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
               SizedBox(height: 10.pixelScale(context)),

              /*SizedBox(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Signed Up successfully!")));
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
              ),*/
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
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
