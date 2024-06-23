import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gameonconnect/model/game_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gameonconnect/services/wishlist_service.dart';
import 'package:gameonconnect/services/currently_playing_service.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';


class GameDetailsPage extends StatefulWidget {
  const GameDetailsPage({super.key, required this.gameId});
  final int gameId;

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  // late GameDetailsPageModel _model;
  late Future<GameDetails> _gameDetails;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final wishlist = Wishlist();
  final currentlyPlaying = CurrentlyPlaying();
  @override
  void initState() {
    super.initState();
    _gameDetails = _fetchGameDetails(widget.gameId);
  }

  Future<GameDetails> _fetchGameDetails(int gameId) async {
    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games/$gameId?key=b8d81a8e79074f1eb5c9961a9ffacee6'));

    if (response.statusCode == 200) {
      return GameDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load game details');
    }
  }

  Future shareLink(String link, String message) async {
    await FlutterShare.share(title: "Share Game", text: message, linkUrl: link);
  }

  // @override
  // void dispose() {
  //   // _model.dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: FutureBuilder<GameDetails>(
          future: _gameDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final gameDetails = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 230,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.network(
                                  gameDetails.backgroundImage,
                                ).image,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 2,
                                  color: Color(0x17202529),
                                  offset: Offset(
                                    0.0,
                                    1,
                                  ),
                                )
                              ],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 50, 16, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(
                                                  0.1), // Adapt to your theme
                                          borderRadius: BorderRadius.circular(
                                              30), // Rounded corners
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary, // Adapt to your theme
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Use Navigator.pop instead of context.pop
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(-1, -1),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Align(
                                    alignment: const Alignment(-1, 0),
                                    child: Text(
                                      gameDetails.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                            fontSize: 32,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                //const Spacer(), // To push the icons to the rightmost side
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 5,
                                          5), // Adjust top, left, right padding as needed
                                      child: Icon(
                                        Icons.favorite_border,
                                        color: Color(0xFF00DF67),
                                        size: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0,
                                          20,
                                          20,
                                          5), // Adjust top, left, right padding as needed
                                      child: IconButton(
                                        icon: const Icon(Icons.share_outlined),
                                        color: const Color(0xFF00DF67),
                                        onPressed: () {
                                          final String link =
                                              gameDetails.website;
                                          const String message =
                                              "Check out the "
                                              "game I found on GameOnConnect!";
                                          shareLink(link, message);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                            child: Text(
                              gameDetails.publisher[0]['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontFamily: 'Inter',
                                    color: Colors.black,
                                    fontSize: 12,
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  20, // Subtracting 20 for padding on both sides
                              child: const Divider(
                                thickness: 1,
                                indent: 0,
                                color: Color(0xCC929292),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 12, 10, 0),
                                child: Container(
                                  width: 110,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Align(
                                        alignment: Alignment(0, -1),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'RATINGS',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color(
                                                  0xFF00DF67), // Direct color value or use Theme.of(context).colorScheme.primary
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight
                                                  .w500, // Adjust font weight if needed
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0, 1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                              gameDetails.rating.toString(),
                                              //ratings
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors
                                                    .black, // Direct color value or use Theme.of(context).colorScheme.primary
                                                fontSize: 16,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 12, 10, 0),
                                child: Container(
                                  width: 110,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Align(
                                        alignment: AlignmentDirectional(0, -1),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'SCORE',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color(
                                                  0xFF00DF67), // Direct color value or use Theme.of(context).colorScheme.primary
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0, 1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                            gameDetails.score.toString(),
                                            //gameDetails.score,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              color: Colors
                                                  .black, // Direct color value or use Theme.of(context).colorScheme.primary
                                              fontSize: 16,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Flexible(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 12, 10, 0),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          const Align(
                            alignment: Alignment(-1, -1),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                              child: Text(
                                'About',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors
                                      .black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                  fontSize: 20,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, -1),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.network(
                                  gameDetails.backgroundImage,
                                  //'https://picsum.photos/seed/239/600',
                                  width: 464,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 6, 10, 6),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        child: Image.network(
                                          // TODO : use the get screenshots function for this
                                          // gameDetails.screenshots[0],
                                          'https://picsum.photos/seed/194/600',
                                          width: 80,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        child: Image.network(
                                          // gameDetails.screenshots[1],
                                          'https://picsum.photos/seed/170/600',
                                          width: 80,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          // gameDetails.screenshots[2],
                                          'https://picsum.photos/seed/185/600',
                                          width: 80,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          // gameDetails.screenshots[3],
                                          'https://picsum.photos/seed/137/600',
                                          width: 80,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          // gameDetails.screenshots[4],
                                          'https://picsum.photos/seed/962/600',
                                          width: 80,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Html(
                                data: gameDetails.description,
                                //TODO : character representation is weird
                                style: {
                                  "body": Style(
                                    fontFamily: 'Inter',
                                    color: Colors.black,
                                    // Direct color value or use Theme.of(context).colorScheme.onBackground
                                    letterSpacing: 0,
                                    fontSize: FontSize(16.0),
                                    // Adjust font size as needed
                                    fontWeight: FontWeight.normal,
                                    // Adjust font weight as needed
                                  ),
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  20, // Subtracting 20 for padding on both sides
                              child: const Divider(
                                thickness: 1,
                                indent: 0,
                                color: Color(0xCC929292),
                              ),
                            ),
                          ),
                          const Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  'Platforms',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black,
                                    letterSpacing: 0,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),

                              Spacer(), // This spacer will push the icons to the right edge
                              Row(
                                // TODO: get icons for the different platforms
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(4, 2, 2, 2),
                                    child: Icon(
                                      Icons.window_sharp,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(4, 2, 2, 2),
                                    child: Icon(
                                      Icons.videogame_asset,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(4, 2, 20, 2),
                                    child: Icon(
                                      Icons.games_rounded,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  20, // Subtracting 20 for padding on both sides
                              child: const Divider(
                                thickness: 1,
                                indent: 0,
                                color: Color(0xCC929292),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Flexible(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Developer',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors
                                          .black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                      letterSpacing: 0,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(215, 0, 20, 0),
                                child: Text(
                                  // gameDetails.developer,
                                  gameDetails.publisher[0]['name'],
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors
                                        .black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  20, // Subtracting 20 for padding on both sides
                              child: const Divider(
                                thickness: 1,
                                indent: 0,
                                color: Color(0xCC929292),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Flexible(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Publisher',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors
                                          .black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(223, 0, 20, 0),
                                child: Text(
                                  // gameDetails.publisher,
                                  gameDetails.publisher[0]['name'],
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors
                                        .black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  20, // Subtracting 20 for padding on both sides
                              child: const Divider(
                                thickness: 1,
                                indent: 0,
                                color: Color(0xCC929292),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Flexible(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      6, 0, 0, 0),
                                  child: Text(
                                    'Release Date',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors
                                          .black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    202, 0, 20, 0),
                                child: Text(
                                  gameDetails.released,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors
                                        .black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  20, // Subtracting 20 for padding on both sides
                              child: const Divider(
                                thickness: 1,
                                indent: 0,
                                color: Color(0xCC929292),
                              ),
                            ),
                          ),
                          const Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                  child: Text(
                                    'Genres',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors
                                          .black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                      fontSize: 14,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                              /*Padding(
                                    padding: const EdgeInsets.fromLTRB(120, 0, 4, 0),
                                    child: Text(
                                      //TODO: we need to get the genres from another request
                                       gameDetails.genres[0],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                        letterSpacing: 0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),*/
                              /* Padding(
                                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                    child: Text(
                                       gameDetails.genres[1],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                        letterSpacing: 0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),*/
                              /* Padding(
                                    padding: const EdgeInsets.fromLTRB(4, 0, 20, 0),
                                    child: Text(
                                       gameDetails.genres[2],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.black, // Direct color value or use Theme.of(context).colorScheme.onBackground
                                        letterSpacing: 0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),*/
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  20, // Subtracting 20 for padding on both sides
                              child: const Divider(
                                thickness: 1,
                                indent: 0,
                                color: Color(0xCC929292),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20, 10, 20, 0), // Outer padding
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5), // Space between buttons
                                    child: ElevatedButton(
                                      onPressed: () {
                                        wishlist.addToWishlist(
                                            gameDetails.id.toString());
                                        //TODO: add functionality to change button text
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .all<Color>(const Color(
                                                0xFF00DF67)), // Replace with your desired color
                                        padding: WidgetStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          const EdgeInsets.fromLTRB(
                                              24, 0, 24, 0),
                                        ),
                                        elevation:
                                            WidgetStateProperty.all<double>(3),
                                        shape: WidgetStateProperty.all<
                                            OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add to wishlist',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors
                                              .black, // Replace with your desired text color
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5), // Space between buttons
                                    child: ElevatedButton(
                                      onPressed: () {
                                        currentlyPlaying.addToCurrentlyPlaying(
                                            gameDetails.id.toString());
                                        // TODO : change text to show its added
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .all<Color>(Colors
                                                .white), // Replace with your desired button background color
                                        padding: WidgetStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          const EdgeInsets.fromLTRB(
                                              24, 0, 24, 0),
                                        ),
                                        elevation:
                                            WidgetStateProperty.all<double>(3),
                                        shape: WidgetStateProperty.all<
                                            OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: const BorderSide(
                                              color: Color(
                                                  0xFF00DF67), // Replace with your desired border color
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add to currently playing',
                                        style: TextStyle(
                                          fontFamily:
                                              'Inter', // Replace with your desired font family if needed
                                          color: Colors
                                              .black, // Replace with your desired text color
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*const Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                              child: Text(
                                'System Requirements',
                                style: TextStyle(
                                  fontFamily: 'Inter', // Replace with your desired font family if needed
                                  color: Colors.black, // Replace with your desired text color
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 0), // Outer padding
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 5), // Space between sections
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 2, 2, 6),
                                            child: Text(
                                              'Minimum',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                            child: Text(
                                              'Windows OS',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              'Windows 10 - 64-Bit',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 6, 2, 2),
                                            child: Text(
                                              'Processor',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              'Intel Core i5-6600K @ 3.50GHz\nAMD Ryzen 5 1600 @ 3.7GHz',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 6, 2, 2),
                                            child: Text(
                                              'Storage',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              '100 GB',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 6, 2, 2),
                                            child: Text(
                                              'Memory',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              '8 GB',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 6, 2, 2),
                                            child: Text(
                                              'Graphics',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              'NVIDIA GeForce GTX 1050 Ti 4GB\nAMD Radeon RX 570 4GB',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 280,
                                    child: VerticalDivider(
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5), // Space between sections
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 2, 2, 6),
                                            child: Text(
                                              'Recommended',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                            child: Text(
                                              'Windows OS',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              'Windows 10 - 64-Bit',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 6, 2, 2),
                                            child: Text(
                                              'Processor',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              'Intel Core i7-6700 @ 3.40GHz\nAMD Ryzen 7 2700X @ 3.7GHz',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 6, 2, 2),
                                            child: Text(
                                              'Storage',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              '100 GB',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 6, 2, 2),
                                            child: Text(
                                              'Memory',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              '12 GB',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 6, 2, 2),
                                            child: Text(
                                              'Graphics',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child: Text(
                                              'NVIDIA GeForce GTX 1660\nAMD RX 5600 XT',
                                              style: TextStyle(
                                                fontFamily: 'Inter', // Replace with your desired font family if needed
                                                color: Colors.black, // Replace with your desired text color
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                           Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
                            child: Text(
                              'Buy ${gameDetails.name}:',
                              style: const TextStyle(
                                fontFamily:
                                    'Inter', 
                                color: Colors.black, 
                                fontSize: 20,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 6, 5, 6),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child:  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      IconButton(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            76, 4, 0, 0),
                                        onPressed: () async {
                                          final Uri url = Uri.parse(gameDetails.website);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            print('Could not launch $url');
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.open_in_new,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                      const Padding(
                                        padding:  EdgeInsetsDirectional.fromSTEB(
                                            4, 8, 4, 4),
                                        child: Icon(
                                          Icons.videogame_asset,
                                          color: Color(0xFF00DF67),
                                          size: 36,
                                        ),
                                      ),
                                      // Text(
                                      //   'STORE',
                                      //   style: TextStyle(
                                      //     fontFamily:
                                      //         'Readex Pro', 
                                      //     color: Colors
                                      //         .white, 
                                      //     fontSize: 12,
                                      //     letterSpacing: 0,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              /*Padding(
                                padding: const EdgeInsets.fromLTRB(5, 6, 5, 6),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .black, 
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Icon(
                                          Icons.open_in_new,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Icon(
                                          Icons.videogame_asset,
                                          color: Color(0xFF00DF67),
                                          size: 36,
                                        ),
                                      ),
                                      Text(
                                        'EPIC GAMES',
                                        style: TextStyle(
                                          fontFamily:
                                              'Readex Pro', // Replace with your desired font family
                                          color: Colors
                                              .white, // Replace with your desired text color
                                          fontSize: 12,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),*/
                              /*Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5, 6, 5, 6),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            76, 4, 0, 0),
                                        child: Icon(
                                          Icons.open_in_new,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 8, 4, 8),
                                        child: Icon(
                                          Icons.videogame_asset,
                                          color: Color(0xFF00DF67),
                                          size: 36,
                                        ),
                                      ),
                                      Text(
                                        'PS STORE',
                                        style: TextStyle(
                                          fontFamily:
                                              'Readex Pro', // Replace with your desired font family
                                          color: Colors
                                              .white, // Replace with your desired text color
                                          fontSize: 12,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
