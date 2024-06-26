import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF80D832),
        automaticallyImplyLeading: false,
        title: const Text(
          key: Key('Settings'),
          'Settings\n',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          key: const Key('back_button'),
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: const [
                    ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Color(0xFF80D832),
                      ),
                      title: Text(
                        'Edit Profile',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      dense: false,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/customize');
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.dashboard_customize,
                    color: Color(0xFF80D832),
                  ),
                  title: Text(
                    key: Key('Customize_Profile'),
                    'Customize Profile',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  dense: false,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/help');
                },
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: const [
                    ListTile(
                      leading: Icon(
                        Icons.help_outline_rounded,
                        color: Color(0xFF80D832),
                      ),
                      title: Text(
                        key: Key('Help_Centre'),
                        'Help Centre',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      dense: false,
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // closing the drawer
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                      });
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFFE66C56),
                      ),
                      title: Text(
                        key: Key('Logout'),
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                      dense: false,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
