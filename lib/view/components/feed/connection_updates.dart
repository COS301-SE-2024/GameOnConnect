import 'package:flutter/material.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/view/components/feed/connection_update.dart';
import '../../../model/connection_M/user_model.dart' as user;

class ConnectionUpdates extends StatefulWidget {
  const ConnectionUpdates({super.key});

  @override
  State<ConnectionUpdates> createState() => _ConnectionUpdatesState();
}

class _ConnectionUpdatesState extends State<ConnectionUpdates> {
  final ConnectionService _connectionService = ConnectionService();
  List<user.AppUser>? _connectionRequests;

  @override
  void initState() {
    super.initState();
    _fetchConnectionRequests();
  }

  Future<void> _fetchConnectionRequests() async {
    try {
      print(_connectionService.getConnectionlist("requests"));
      List<user.AppUser>? connectionRequests =
          await _connectionService.getConnectionlist("requests");

      setState(() {
        _connectionRequests = connectionRequests;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _connectionRequests == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _connectionRequests!.length,
                  itemBuilder: (context, index) {
                    final appUser = _connectionRequests![index];
                    return ConnectionUpdateCard(
                      user: appUser.username,
                      connectionStatus: "connect",
                    );
                  },
                ),
            ),
          ],
        );
  }
}
