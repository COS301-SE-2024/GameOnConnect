import '../authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          title: Text(
            'Settings',
            style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0,
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
                  children:  [
                    ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title:  Text(
                        'Edit Profile',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Inter',
                          fontSize: 22,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing:  Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.secondary,
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
                child:  ListTile(
                  leading: Icon(
                    Icons.dashboard_customize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    key: const Key('Customize_Profile'),
                    'Customize Profile',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Inter',
                      fontSize: 22,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.secondary,
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
                  children:  [
                    ListTile(
                      leading: Icon(
                        Icons.help_outline_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        key: const Key('Help_Centre'),
                        'Help Centre',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Inter',
                          fontSize: 22,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.secondary,
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
                    child:  ListTile(
                      leading: const Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFFE66C56),
                      ),
                      title: Text(
                        key: const Key('Logout'),
                        'Logout',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Inter',
                          fontSize: 22,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing:  Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
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
