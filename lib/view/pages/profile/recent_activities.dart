import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/view/pages/game_library/game_details_page.dart';
import 'package:gameonconnect/view/pages/profile/recent_activity_table.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../model/Stats_M/game_stats.dart';


class RecentActivityList extends StatefulWidget {
  RecentActivityList({super.key, 
    required this. gameStats,
    required this.heading,
  }) ;
  //final List<String>  gameIds;
  List<GameStats> gameStats;
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

 DateTime _parseTimestampString(String timestampString) {
  try {
    return DateTime.parse(timestampString);
  } catch (e) {
    print('Error parsing timestamp string: $e');
    return DateTime.now(); // Return current date/time as a fallback
  }
}

// Format DateTime as date (e.g., "17 July 2024")
String _formatDate(DateTime dateTime) {
  return '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
}

// Format DateTime as time (e.g., "19:30")
String _formatTime(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

// Helper function to get month name
String _getMonthName(int month) {
  const monthNames = [
    '', // Placeholder for index 0
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return monthNames[month];
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
        if (widget.gameStats.isEmpty)
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
          Column(
            children: [
              SizedBox(
                height: 200, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.gameStats.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<GameDetails>(
                      future: GameService().fetchGameDetails(widget.gameStats[index].gameId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('No data'));
                        } else {
                          final gameDetails = snapshot.data!;
                          final gameStats = widget.gameStats[index];
                          final lastPlayedDateTime = _parseTimestampString(gameStats.lastPlayedDate);
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
                                      child:  Column(
                                        children: [
                                          Text(
                                            gameDetails.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,

                                                color: Color(0xFFFFFFFF),
                                              ),
                                              textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Time played(h): ${gameStats.timePlayedLast}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                            Text(
                                              ' Mood: ${gameStats.mood} ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                            
                                            Text(
                                              ' Date: ${_formatDate(lastPlayedDateTime)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                            Text(
                                              ' Time: ${_formatTime(lastPlayedDateTime)} ',
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

              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecentActivityTable())); 

                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      gradient: LinearGradient(
                        begin: Alignment(-1, 0),
                        end: Alignment(1, 0),
                        colors: <Color>[Color(0xFF00FF75), Color(0xFF009946)],
                        stops: <double>[0, 1],
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15.3, 0, 16.3, 0),
                      child: 
                      Text(
                        'see more',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 2.1,
                          letterSpacing: 0.5,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ), 
              ),
            ],
          ),
          
      ],
    );
  }
}


