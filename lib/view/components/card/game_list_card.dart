import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class GameCard extends StatefulWidget {
  final String name;
  final String chosen;
  final void Function(String gameName) onSelected;
  final String image;
  const GameCard({super.key, required this.name,required this.chosen, required this.onSelected, required this.image});

  @override
  State<GameCard> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<GameCard> {
  String name = "";
  bool selected = false;
  String chosen="";
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
              Container(width: 60,
                height: 60, child:
               ClipRRect(
                borderRadius: BorderRadius.circular(44),
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading indicator for banner
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
