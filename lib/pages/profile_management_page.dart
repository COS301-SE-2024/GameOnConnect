
import 'package:flutter/material.dart';

class Item {
  Item({
    required this.headerText,
    required this.expandedText,
    this.expanded = false
  });
  String headerText;
  String expandedText;
  bool expanded;
}
List<Item> getItems() {
  return [
    Item(headerText: 'Change my username', expandedText: 'To change your '
        'username, navigate to the settings on your profile page,'
        'and then select the Edit Profile option.'),
    Item(headerText: 'Change my first name', expandedText: 'To change your '
        'first name, navigate to the settings on your profile page,'
        'and then select the Edit Profile option.')
  ];
}


class ProfileManagement extends StatelessWidget{
  const ProfileManagement({super.key});
  //List<Item> items = getItems();
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

      ),
    );
  }

}