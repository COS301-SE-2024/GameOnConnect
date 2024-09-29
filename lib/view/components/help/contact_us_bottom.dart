import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactUsBar extends StatelessWidget {
  const ContactUsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(
            const ClipboardData(text: "support@gameonconnect.com"),
          );
         /* ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Email copied to clipboard'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );*/
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                const Text("gameonconnect.help@gmail.com"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}