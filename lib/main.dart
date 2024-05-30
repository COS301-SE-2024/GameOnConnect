// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gameonconnect/pages/customize_page.dart';
import 'pages/home_page.dart';
import 'firebase_options.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  // This is the root of our application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameOnConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      routes: {
        '/' : (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData) {
              return HomePage(title: 'GameOnConnect',);
            } else {
              return const Login();
            }
          },
        ),
        '/home' : (context) => HomePage(title: 'GameOnConnect',),
       '/customize' : (context) => CustomizeProfilePage(),
      },
      initialRoute: '/',
    );
  }
}


