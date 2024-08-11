import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import '../authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        title: 'Settings',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        iconkey: const Key('Back_button_key'),
        textkey: const Key('settings_text'),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.edit_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),
                ]
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              thickness: 1,
              indent: 12,
              endIndent: 12,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.dashboard_customize_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      'Customize Profile',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/customize');
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              thickness: 1,
              indent: 12,
              endIndent: 12,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.help_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      'Help',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/help');
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              thickness: 1,
              indent: 12,
              endIndent: 12,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}