// ignore_for_file: prefer_const_constructors

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:gameonconnect/view/pages/messaging/messaging_page.dart';
import 'package:gameonconnect/view/pages/settings/appearance.dart';
import 'package:gameonconnect/view/pages/settings/customize_page.dart';
import 'package:gameonconnect/view/pages/game_library/game_library_page.dart';
import 'package:gameonconnect/view/pages/settings/getting_started_page.dart';
import 'package:gameonconnect/view/pages/settings/settings_page.dart';
import 'package:gameonconnect/view/theme/theme_provider.dart';
import 'package:gameonconnect/view/pages/authentication/sign_up_page.dart';
import 'view/pages/settings/help_page.dart';
import 'package:provider/provider.dart';
import 'view/pages/home/home_page.dart';
import 'view/pages/events/create_events_page.dart';
import 'view/pages/events/view_events_page.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'view/pages/authentication/login_page.dart';
import 'view/pages/settings/edit_profile_page.dart';
import 'view/pages/connections/connection_requests_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  globals.apiKey = dotenv.env['RAWG_API_KEY'];
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  
  //TO turn off APP check
  //FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);

  Future<void> fetchUserTheme(ThemeProvider themeProvider) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot userDoc =
          await db.collection('profile_data').doc(user.uid).get();

      if (userDoc.exists) {
        String theme = userDoc['theme'] as String;
        if (theme == 'dark_green') {
          themeProvider.setDarkGreenMode();
        } else if (theme == 'light_green') {
          themeProvider.setLightGreenMode();
        } else if (theme == 'dark_purple') {
          themeProvider.setDarkPurpleMode();
        } else if (theme == 'light_purple') {
          themeProvider.setLightPurpleMode();
        } else if (theme == 'dark_blue') {
          themeProvider.setDarkBlueMode();
        } else if (theme == 'light_blue') {
          themeProvider.setLightBlueMode();
        } else if (theme == 'dark_orange') {
          themeProvider.setDarkOrangeMode();
        } else if (theme == 'light_orange') {
          themeProvider.setLightOrangeMode();
        } else if (theme == 'dark_pink') {
          themeProvider.setDarkPinkMode();
        } else if (theme == 'light_pink') {
          themeProvider.setLightPinkMode();
        }
      }
    }
  }

  ThemeProvider themeProvider = ThemeProvider();

  await fetchUserTheme(themeProvider);

  runApp(
      ChangeNotifierProvider.value(value: themeProvider, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameOnConnect',
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.hasData) {
                  return HomePage(
                    title: 'GameOnConnect',
                  );
                } else {
                  return const Login();
                }
              },
            ),
        '/home': (context) => HomePage(
              title: 'GameOnConnect',
            ),
        '/edit-profile': (context) => EditProfilePage(),
        '/customize': (context) => CustomizeProfilePage(),
        '/sign_up': (context) => SignUp(),
        //'/profile': (context) => Profilenew(),
        '/game_library': (context) => GameLibrary(),
        '/create_events': (context) => CreateEvents(),
        '/events': (context) => ViewEvents(),
        '/login': (context) => Login(),
        '/help': (context) => Help(),
        '/getting_started': (context) => GettingStarted(),
        '/settings' : (context) => Options(),
        '/requests' : (context) => Requests(),
        '/messages' : (context) => Messaging(),
        '/appearance' : (context) => AppearancePage(),
      },
      initialRoute: '/',
    );
  }
}
