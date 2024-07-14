import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/friend_model.dart';

class CurrentlyOnlineBar extends StatefulWidget {
  const CurrentlyOnlineBar({super.key});

  @override
  State<CurrentlyOnlineBar> createState() => _CurrentlyOnlineBarState();
}

class _CurrentlyOnlineBarState extends State<CurrentlyOnlineBar> {
  final List<String> _friends = ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7'];
  final List<String> _images = ['https://placehold.co/70x70']; //change to friend objects later

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
                  ),
                  child: CircleAvatar(
                        backgroundImage: NetworkImage(_images[0]),
                  ),
                ),
                Text(_friends[index])
              ],
            ),
          );
        }
      )
    );
  }
}