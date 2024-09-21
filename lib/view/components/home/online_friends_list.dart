import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart' as user;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pulsator/pulsator.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          maxWidth: MediaQuery.of(context).size.width, maxHeight: 100),
      child: _isLoading
          ? Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 36,
              ),
            )
          : _friends != null
              ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    const Text("No friends online \nright now :(",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SvgPicture.asset(
                      'assets/images/sad_icon.svg',
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  ]))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _friends!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Pulsator(
                              style: PulseStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              count: 3,
                              duration: const Duration(seconds: 2),
                              autoStart: true,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      _friends![index].profilePicture),
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
