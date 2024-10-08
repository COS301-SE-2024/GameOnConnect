import 'package:flutter/material.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/view/components/home/connection_update.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../model/connection_M/user_model.dart';

class ConnectionUpdates extends StatefulWidget {
  const ConnectionUpdates({super.key});

  @override
  State<ConnectionUpdates> createState() => _ConnectionUpdatesState();
}

class _ConnectionUpdatesState extends State<ConnectionUpdates> {
  final ConnectionService _connectionService = ConnectionService();
  late Future<List<AppUser>?> _connectionRequests;

  @override
  void initState() {
    super.initState();
    _connectionRequests = _fetchConnectionRequests();
  }

  Future<List<AppUser>?> _fetchConnectionRequests() async {
    try {
      return await _connectionService.getConnectionlist("requests");
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppUser>?>(
        future: _connectionRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 36,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No new connection updates 😊'));
          } else {
            final connectionRequests = snapshot.data!;
            return ConstrainedBox(
              constraints:  const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: connectionRequests.length,
                itemBuilder: (context, index) {
                  final appUser = connectionRequests[index];
                  return ConnectionUpdateCard(
                    user: appUser.username,
                    connectionStatus: "connect",
                  );
                },
              ),
            );
          }
        });
  }
}
