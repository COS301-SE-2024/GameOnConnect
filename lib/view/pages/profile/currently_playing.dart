import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';

class CurrentlyPlaying extends StatefulWidget {
  const CurrentlyPlaying({super.key, required this.gameId});
  final int gameId;

  @override
  State<CurrentlyPlaying> createState() => _CurrentlyPlayingState();
}

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameDetails>(
      future: GameService().fetchGameDetails(widget.gameId),
      builder: (context, gameSnapshot) {
        if (gameSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (gameSnapshot.hasError) {
          return Text('Error: ${gameSnapshot.error}');
        } else {
          final gameDetails = gameSnapshot.data!;
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                    'Currently playing ',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(7, 4, 8.1, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00FF75)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Start of currently playing image
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 3.5, 3),
                                width: 147,
                                height: 101,
                                child: CachedNetworkImage(
                                  imageUrl: gameDetails.backgroundImage,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Game details
                              Expanded(
                                // ignore: avoid_unnecessary_containers
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        gameDetails.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        softWrap: true,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(0, 0, 13.9, 7.3),
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEE1313),
                                                  borderRadius: BorderRadius.circular(3),
                                                ),
                                                child: Container(
                                                  padding: const EdgeInsets.fromLTRB(7, 4, 9.5, 3),
                                                  child: const Text(
                                                    'LIVE',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 15,
                                                    ),
                                                  ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
