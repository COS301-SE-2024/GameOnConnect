import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart' as user;

class CurrentlyOnlineBar extends StatefulWidget {
  const CurrentlyOnlineBar({super.key});

  @override
  State<CurrentlyOnlineBar> createState() => _CurrentlyOnlineBarState();
}

class _CurrentlyOnlineBarState extends State<CurrentlyOnlineBar> {
  List<user.AppUser>? _friends = [];
  final List<String> _images = ['https://placehold.co/70x70'];
  final ConnectionService _connectionService = ConnectionService();

  @override
  void initState() {
    super.initState();
    _fetchOnlineFriends();
  }

  Future<void> _fetchOnlineFriends() async {
    List<AppUser>? onlineUsers = await _connectionService.getOnlineConnections();
    print(onlineUsers);

    setState(() {
      _friends = onlineUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _friends!.length,
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
                Text(_friends![index].username)
              ],
            ),
          );
        }
      )
    );
  }
}