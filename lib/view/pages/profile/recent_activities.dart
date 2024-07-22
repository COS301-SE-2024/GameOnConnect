import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/view/pages/game_library/game_details_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../model/Stats_M/game_stats.dart';


class RecentActivityList extends StatefulWidget {
  RecentActivityList({super.key, 
    required this. gameIds,
    required this.heading,
  }) ;
  //final List<String>  gameIds;
  List<GameStats> gameIds;
  final String heading;

  @override
  State<RecentActivityList> createState() => _RecentActivityListState();
}

class _RecentActivityListState extends State<RecentActivityList> {

 void _navigateToGameDetails(int game) async {
    // ignore_for_file: use_build_context_synchronously
    bool result = await InternetConnection().hasInternetAccess;
    if(result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailsPage(gameId: game),
        ),
      );
    }else
      {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Unable to fetch data, check internet connection"),
              backgroundColor: Colors.red,
            ));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.heading,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        if (widget.gameIds.isEmpty)
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
                      Text('You have no ${widget.heading} from the past 2 weeks'),
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add),
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
            height: 150, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.gameIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<GameDetails>(
                  future: GameService().fetchGameDetails(widget.gameIds[index].gameId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data'));
                    } else {
                      final gameDetails = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:InkWell(
                          onTap: () {
                            _navigateToGameDetails(gameDetails.id);
                            
                          },
                          child: Container(
                          height: 150,
                          width: 150,
                  //margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
  //border: Border.all(color: const Color(0xFF00FF75)),
  borderRadius: BorderRadius.circular(10),
  color: Colors.grey[850],
  image: DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage(
      //'assets/images/image_3.png',
      gameDetails.backgroundImage, // cache
    ),
    
    colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.2), // Adjust opacity here
        BlendMode.dstATop, // Use dstATop for transparency
      ),
    
  ),
),

                  child:Column(
  children: [
    Container(
      padding: const EdgeInsets.fromLTRB(18, 11, 3.2, 5.3),
      child: const Column(
        children: [
          Text(
            'Fornite',
              style: TextStyle(
                fontWeight: FontWeight.w700,

                color: Color(0xFFFFFFFF),
              ),
          ),
          const SizedBox(height: 8),
          Text(
            'Time played:30 ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFFFFFFFF),
              ),
            ),
            Text(
              ' Mood: Joy ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFFFFFFFF),
              ),
            ),
            Text(
              ' Date: 17 July 2024 ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFFFFFFFF),
              ),
            ),
            Text(
              ' Time: 19:30 ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFFFFFFFF),
              ),
            ),
        ],
      ),
      
    ),
  ],
),

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


