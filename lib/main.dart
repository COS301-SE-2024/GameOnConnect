// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gameonconnect/pages/customize_page.dart';
import 'package:gameonconnect/theme/theme_provider.dart';
import 'package:gameonconnect/pages/sign_up.dart';
import 'package:gameonconnect/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'firebase_options.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/edit_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp())
    );
}

//ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  // This is the root of our application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameOnConnect',
      theme: Provider.of<ThemeProvider>(context).themeData,
      //themeMode: _themeManager.themeMode,
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
        '/edit-profile' : (context) => EditProfilePage(),
       '/customize' : (context) => CustomizeProfilePage(),
        '/sign_up' : (context) => SignUp(),
        '/profile' : (context) => Profile(),
      },
      initialRoute: '/',
     //home: Profile()
    );
  }
}


