import 'package:cached_network_image/cached_network_image.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import '../../../services/game_library_S/game_service.dart';
import 'dart:async';
import 'package:gameonconnect/services/game_library_S/want_to_play_service.dart';
import 'package:gameonconnect/services/game_library_S/my_games_service.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/components/game_library/carousel_image.dart';

class GameDetailsPage extends StatefulWidget {
  const GameDetailsPage({super.key, required this.gameId});
  final int gameId;

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  late Future<GameDetails> _gameDetails;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Wishlist wishlist = Wishlist();
  bool isInWishlist = false;

  
  final myGames = MyGamesService();
  bool isInMyGames = false;

  @override
  void initState() {
    super.initState();
    _gameDetails = _fetchGameDetails(widget.gameId);
    checkWishlistStatus();
    checkMyGamesStatus();
  }

  Future<void> checkWishlistStatus() async {
    List<String> currentWishlist = await wishlist.getWishlist();
    setState(() {
      isInWishlist = currentWishlist.contains(widget.gameId.toString());
    });
  }


  Future<void> checkMyGamesStatus() async {
    List<String> currentMyGames = await myGames.getMyGames();

    setState(() {
      isInMyGames = currentMyGames.contains(widget.gameId.toString());
    });
  }

  Future<GameDetails> _fetchGameDetails(int gameId) async {
    try {
      bool result = await InternetConnection().hasInternetAccess;
      if (result) {
        return GameService().fetchGameDetails(gameId);
      } else {
        throw ('No internet connection');
      }
    } catch (e) {
      throw ('Error fetching data');
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: FutureBuilder<GameDetails>(
          future: _gameDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Please check your internet connection"),
                backgroundColor: Colors.red.shade300,
              ));
              return const SizedBox.shrink();
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
                                image: CachedNetworkImageProvider(
                                  gameDetails.backgroundImage,
                                ),
                                fit: BoxFit.cover,
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
                                                  0.6), // Adapt to your theme
                                          borderRadius: BorderRadius.circular(
                                              30), // Rounded corners
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary, // Adapt to your theme
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0,
                                          20,
                                          5,
                                          5), // Adjust top, left, right padding as needed
                                      child: Icon(
                                        Icons.play_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
                              child: Divider(
                                thickness: 1,
                                indent: 0,
                                color: Theme.of(context).colorScheme.secondary,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const Alignment(0, -1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            'RATINGS',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
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
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0, -1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            'SCORE',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
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
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
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
                          Align(
                            alignment: const Alignment(-1, -1),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                              child: Text(
                                'About',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                              child: CarouselNetworkImageWithPlaceholder(
                                imageUrl: gameDetails.backgroundImage,
                                width: 464,
                                height: 200,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    CarouselNetworkImageWithPlaceholder(
                                      imageUrl:
                                          'https://picsum.photos/seed/194/600',
                                      width: 80,
                                      height: 55,
                                    ),
                                    CarouselNetworkImageWithPlaceholder(
                                      imageUrl:
                                          'https://picsum.photos/seed/170/600',
                                      width: 80,
                                      height: 55,
                                    ),
                                    CarouselNetworkImageWithPlaceholder(
                                      imageUrl:
                                          'https://picsum.photos/seed/185/600',
                                      width: 80,
                                      height: 55,
                                    ),
                                    CarouselNetworkImageWithPlaceholder(
                                      imageUrl:
                                          'https://picsum.photos/seed/137/600',
                                      width: 80,
                                      height: 55,
                                    ),
                                    CarouselNetworkImageWithPlaceholder(
                                      imageUrl:
                                          'https://picsum.photos/seed/962/600',
                                      width: 80,
                                      height: 55,
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
                              child: Divider(
                                thickness: 1,
                                indent: 0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  'Platforms',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    letterSpacing: 0,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),

                              const Spacer(), // This spacer will push the icons to the right edge
                              Row(
                                // TODO: get icons for the different platforms
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 2, 2, 2),
                                    child: Icon(
                                      Icons.window_sharp,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 24,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(4, 2, 2, 2),
                                    child: Icon(
                                      Icons.videogame_asset,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  const Padding(
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
                              child: Divider(
                                thickness: 1,
                                indent: 0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Developer',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
                              child: Divider(
                                thickness: 1,
                                indent: 0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Publisher',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
                              child: Divider(
                                thickness: 1,
                                indent: 0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      6, 0, 0, 0),
                                  child: Text(
                                    'Release Date',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
                              child: Divider(
                                thickness: 1,
                                indent: 0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                  child: Text(
                                    'Genres',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                              child: Divider(
                                thickness: 1,
                                indent: 0,
                                color: Theme.of(context).colorScheme.secondary,
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
                                      onPressed: () async {
                                        if (isInWishlist) {
                                          await wishlist.removeFromWishlist(
                                              gameDetails.id.toString());
                                          // ignore: use_build_context_synchronously
                                          DelightToastBar(
                                            builder: (context) {
                                              return CustomToastCard(
                                                title: Text(
                                                  'Removed from Want to Play!',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                              );
                                            },
                                            position:
                                                DelightSnackbarPosition.top,
                                            autoDismiss: true,
                                            snackbarDuration:
                                                const Duration(seconds: 3),
                                          ).show(
                                            // ignore: use_build_context_synchronously
                                            context,
                                          );
                                        } else {
                                          await wishlist.addToWishlist(
                                              gameDetails.id.toString());
                                          // ignore: use_build_context_synchronously
                                          DelightToastBar(
                                                  builder: (context) {
                                                    return CustomToastCard(
                                                      title: Text(
                                                        'Added to Want to Play!',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  position:
                                                      DelightSnackbarPosition
                                                          .top,
                                                  autoDismiss: true,
                                                  snackbarDuration:
                                                      const Duration(
                                                          seconds: 3))
                                              .show(
                                            // ignore: use_build_context_synchronously
                                            context,
                                          );
                                        }
                                        // setState(() {
                                        //   isInWishlist = !isInWishlist;
                                        // });
                                        checkWishlistStatus();
                                      },
                                      // child: ElevatedButton(
                                      // onPressed: () {
                                      //   wishlist.addToWishlist(
                                      //       gameDetails.id.toString());
                                      //    ScaffoldMessenger.of(context).showSnackBar(
                                      //       const SnackBar(
                                      //         content: Text(
                                      //             "Added to wishlist!"),
                                      //         backgroundColor: Colors.green,
                                      //       ));
                                      //
                                      // },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary),
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
                                      child: Text(
                                        isInWishlist
                                            ? 'Remove from Want to Play'
                                            : 'Add to Want to Play',
                                        // 'Add to wishlist',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
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

                                    onPressed: () async {
                                      if (isInMyGames) {
                                        await myGames.removeFromMyGames(gameDetails.id.toString());
                                        // ignore: use_build_context_synchronously
                                        DelightToastBar(
                                                builder: (context) {
                                                  return CustomToastCard(
                                                    title: Text(
                                                      'Removed from My Games!',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                position:
                                                    DelightSnackbarPosition.top,
                                                autoDismiss: true,
                                                snackbarDuration:
                                                    const Duration(seconds: 3))
                                            .show(
                                          // ignore: use_build_context_synchronously
                                          context,
                                        );
                                      } else {
                                        await myGames.addToMyGames(gameDetails.id.toString());
                                        // ignore: use_build_context_synchronously
                                        DelightToastBar(
                                                builder: (context) {
                                                  return CustomToastCard(
                                                    title: Text(
                                                      'Added to My Games!',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                      ),
                                                      ),
                                                    );
                                                  },
                                                  position:
                                                      DelightSnackbarPosition
                                                          .top,
                                                  autoDismiss: true,
                                                  snackbarDuration:
                                                      const Duration(
                                                          seconds: 3))
                                              .show(
                                            // ignore: use_build_context_synchronously
                                            context,
                                          );
                                        } /*else {
                                          await currentlyPlaying
                                              .addToCurrentlyPlaying(
                                                  gameDetails.id.toString());
                                          // ignore: use_build_context_synchronously
                                          context,
                                        );
                                      }*/
                                      // setState(() {
                                      //   isInWishlist = !isInWishlist;
                                      // });
                                      checkMyGamesStatus(); 
                                    },
                                    // child: ElevatedButton(
                                    //   onPressed: () {
                                    //     myGames.addTomyGames(
                                    //         gameDetails.id.toString());
                                    //     ScaffoldMessenger.of(context).showSnackBar(
                                    //         const SnackBar(
                                    //           content: Text(
                                    //               "Successfully added game to "
                                    //                   "currently playing list"),
                                    //           backgroundColor: Colors.green,
                                    //         ));
                                    //
                                    //   },

                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
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
                                            side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text(

                                        isInMyGames ? 'Remove from My Games' : 'Add to My Games',

                                        // 'Add to currently playing',
                                        style: TextStyle(
                                          fontFamily:
                                              'Inter', // Replace with your desired font family if needed
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface, // Replace with your desired text color
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 20, 10, 10),
                            child: Text(
                              'Buy ${gameDetails.name}:',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Theme.of(context).colorScheme.secondary,
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
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      IconButton(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(76, 4, 0, 0),
                                        onPressed: () async {
                                          final Uri url =
                                              Uri.parse(gameDetails.website);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        icon: Icon(
                                          Icons.open_in_new,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 12,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 8, 4, 4),
                                        child: Icon(
                                          Icons.videogame_asset,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
