
import 'package:flutter/material.dart';

class GettingStarted extends StatelessWidget{
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('Getting started video - do this when functionality is done'),
      ),
    );
  }

}