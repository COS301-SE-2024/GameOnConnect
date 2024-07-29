import 'package:flutter/material.dart';

class BackButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;
  final Key iconkey;
  final Key textkey;

  const BackButtonAppBar({
    super.key,
    required this.title,
    required this.onBackButtonPressed,
    required this.iconkey,
    required this.textkey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        key: iconkey,
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: onBackButtonPressed,
      ),
      title: Text(
        key: textkey,
        title,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
