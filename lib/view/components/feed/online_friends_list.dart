import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart' as user;
import 'package:pulsator/pulsator.dart';

class CurrentlyOnlineBar extends StatefulWidget {
  const CurrentlyOnlineBar({super.key});

  @override
  State<CurrentlyOnlineBar> createState() => _CurrentlyOnlineBarState();
}

class _CurrentlyOnlineBarState extends State<CurrentlyOnlineBar> {
  List<user.AppUser>? _friends = [];
  final ConnectionService _connectionService = ConnectionService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOnlineFriends();
  }

  Future<void> _fetchOnlineFriends() async {
    setState(() {
      _isLoading = true;
    });

    List<AppUser>? onlineUsers =
        await _connectionService.getOnlineConnections();

    setState(() {
      _friends = onlineUsers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, maxHeight: 130),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _friends!.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Pulsator(
                          style: PulseStyle(
                              color: Theme.of(context).colorScheme.primary),
                          count: 3,
                          duration: const Duration(seconds: 2),
                          autoStart: true,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(_friends![index].profilePicture),
                            ),
                          )),
                    ),
                    Text(_friends![index].username,
                        style: const TextStyle(fontSize: 10)),
                  ],
                );
              }),
    );
  }
}
