import 'package:flutter/material.dart';


class GameCard extends StatefulWidget {
  final name;
  final chosen;
  final void Function(String gameName) onSelected;

  const GameCard({super.key, required this.name,required this.chosen, required this.onSelected});

  @override
  State<GameCard> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<GameCard> {
  String name = "";
  bool selected = false;
  String chosen="";
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    chosen = widget.chosen;

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selected = ( name == widget.chosen);
    return InkWell(
        onTap: (){
          setState(() {
            selected = !selected;
          });
          widget.onSelected(name);

        },
        child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: selected? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
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
