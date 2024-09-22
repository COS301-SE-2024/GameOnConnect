import 'package:flutter/material.dart';

class CustomSnackbar {
  void show(BuildContext context,String title) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(title), backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,));
  }
}
