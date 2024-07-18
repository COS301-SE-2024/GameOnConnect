import 'package:flutter/material.dart';


class GameCard extends StatefulWidget {
  final name;
  final void Function(String uid) onSelected;

  const GameCard({super.key, required this.name, required this.onSelected});

  @override
  State<GameCard> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<GameCard> {
  String name = "";
  String selectedGame = "";
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          setState(() {
            selectedGame = name;
          });
        },
        child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: name == selectedGame? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              color: Theme.of(context).colorScheme.surface,
              offset: const Offset(
                0,
                1,
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color:  Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
