import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  final String name;
  final int gameID;
  final int chosen;
  final void Function(int gameID) onSelected;
  final String image;
  const GameCard(
      {super.key,
      required this.name,
      required this.gameID,
      required this.chosen,
      required this.onSelected,
      required this.image});

  @override
  State<GameCard> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<GameCard> {
  String name = "";
  int gameID = -1;
  bool selected = false;
  int chosen = -1;
  String image = "";
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    chosen = widget.chosen;
    image = widget.image;
    gameID = widget.gameID;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selected = (gameID == widget.chosen);
    return InkWell(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        widget.onSelected(gameID);
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: Container(
          width: double.infinity,
          height: 68,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
            padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 112,
                  height: 67,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      placeholder: (context, url) => const Center(
                          child:
                              CircularProgressIndicator()), // Loading indicator for banner
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface, 
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check,
                            color: Color.fromRGBO(24, 24, 24, 1.0),
                            size: 16,
                          )
                        : null,
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
