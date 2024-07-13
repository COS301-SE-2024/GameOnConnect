import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';


class HorizontalGameList extends StatefulWidget {
  const HorizontalGameList({
    Key? key,
    required this. GameIds,
    required this.heading,
  }) ;
  final List<String>  GameIds;
  final String heading;

  @override
  State<HorizontalGameList> createState() => _HorizontalGameListState();
}

class _HorizontalGameListState extends State<HorizontalGameList> {
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.heading,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        if (widget.GameIds.isEmpty)
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text('You currently don\'t have any games in ${widget.heading}. Would you like to add games?'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Add your function here
                    },
                  ),
                ],
              ),
            ),
          )*/
          Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          children: [
            Text('You currently don\'t have any games in ${widget.heading}. Would you like to add games?'),
            Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Add your function here
                  },
                ),
              ),
          ],
        ),
       
      ],
    ),
  ),
)

        else
          SizedBox(
            height: 200, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.GameIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<GameDetails>(
                  future: GameService().fetchGameDetails(widget.GameIds[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No data'));
                    } else {
                      final gameDetails = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150, // Adjust the width as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: gameDetails.backgroundImage,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  height: 100,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
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


