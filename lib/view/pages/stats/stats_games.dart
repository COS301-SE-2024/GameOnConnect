import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_games_service.dart';

class GamesWidget extends StatefulWidget {
  const GamesWidget({super.key, required this.gameData});
  final List<Map<String, dynamic>> gameData;

  @override
  State<GamesWidget> createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> {
  late Future<List<Map<String, String>>> _gameData;

  @override
  void initState() {
    super.initState();
    _fetchGameData();
  }

  void _fetchGameData() async {
    setState(() {
      _gameData = StatsGamesService().fetchGameImages(widget.gameData); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Games',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22,
            letterSpacing: 0,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _gameData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading game data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No game data available'));
          } else {
            final gameData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: gameData.map((game) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              game['imageUrl']!,
                              width: 170,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
                            child: Text(
                              game['lastPlayed']!,
                              style: TextStyle(
                                fontFamily: 'inter',
                                letterSpacing: 0,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:gameonconnect/services/stats_S/stats_games_service.dart';

// class GamesWidget extends StatefulWidget {
//   const GamesWidget({super.key, required this.gameIDs});
//   final List<String> gameIDs;

//   @override
//   State<GamesWidget> createState() => _GamesWidgetState();
// }

// class _GamesWidgetState extends State<GamesWidget> {
//   late Future<List<String>> _gameImages;

//   @override
//   void initState() {
//     super.initState();
//     _gameImages = StatsGamesService().fetchGameImages(widget.gameIDs);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_rounded,
//             color: Theme.of(context).colorScheme.secondary,
//             size: 30,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text(
//           'Games',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             color: Theme.of(context).colorScheme.secondary,
//             fontSize: 22,
//             letterSpacing: 0,
//           ),
//         ),
//         centerTitle: false,
//         elevation: 2,
//       ),
//       body: FutureBuilder<List<String>>(
//         future: _gameImages,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Error loading game images'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No game images available'));
//           } else {
//             final gameImages = snapshot.data!;
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: gameImages.map((imageUrl) {
//                     return Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.network(
//                           imageUrl,
//                           width: 170,
//                           height: 170,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                   //   ),
//                   //   Padding(
//                   //   padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
//                   //   child: Text(
//                   //     '15 July 2024 at 18:32:08 UTC+2',
//                   //     style: FlutterFlowTheme.of(context).bodyMedium.override(
//                   //           fontFamily: 'Readex Pro',
//                   //           letterSpacing: 0,
//                   //         ),
//                   //   ),
//                   );
//                   }).toList(),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
