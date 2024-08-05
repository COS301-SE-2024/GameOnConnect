import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  final String value;
  final String title;

  const ProfileButton({required this.value, required this.title});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
  
  }


class _ProfileButtonState extends State<ProfileButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8), // Adjust spacing as needed
      child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
    );
    
  }
}
