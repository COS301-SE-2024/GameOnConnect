import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  final String value;
  final String title;
  final VoidCallback? onPressed;
   

  const ProfileButton({super.key, 
    required this.value, 
    required this.title,
     this.onPressed,
 });    

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
  
  }


class _ProfileButtonState extends State<ProfileButton> {

  @override
 Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8), // Adjust spacing as needed
      child: GestureDetector(
        onTap: widget.onPressed, // Handle the onTap event
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
            border: Border.all(color: Theme.of(context).colorScheme.primary),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
