import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';


class HorizontalGameList extends StatefulWidget {
  const HorizontalGameList({
    Key? key,
    required this. myGameIds,
    required this.heading,
  }) ;
  final List<String>  myGameIds;
  final String heading;

  @override
  State<HorizontalGameList> createState() => _HorizontalGameListState();
}

class _HorizontalGameListState extends State<HorizontalGameList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          //padding: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
          child: Text(
            widget.heading,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.myGameIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<GameDetails>(
                future: GameService().fetchGameDetails(widget.myGameIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  } else {
                    final gameDetails = snapshot.data!;
                    return Padding(
                      //padding: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),

                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: gameDetails.backgroundImage,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5),
                          Flexible(
                            child: Text(
                              gameDetails.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              softWrap: true, // This allows the text to wrap when it reaches the edge of the screen
                            ),
                          ),
                          
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


