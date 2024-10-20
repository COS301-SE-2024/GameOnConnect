// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:gameonconnect/view/pages/home/home_page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../services/game_library_S/game_service.dart';
import 'dart:async';
import 'package:gameonconnect/services/game_library_S/want_to_play_service.dart';
import 'package:gameonconnect/services/game_library_S/my_games_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:gameonconnect/view/components/card/custom_snackbar.dart';
import 'package:gameonconnect/view/components/game_library/carousel_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:convert';

class GameDetailsPage extends StatefulWidget {
  const GameDetailsPage({super.key, required this.gameId});
  final int gameId;

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  final BadgeService _badgeService = BadgeService();
  late Future<GameDetails?> _gameDetails;
  late Future<List<Screenshot>?> _gameScreenshots;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Wishlist wishlist = Wishlist();
  bool isInWishlist = false;

  final myGames = MyGamesService();
  bool isInMyGames = false;

  @override
  void initState() {
    super.initState();
    _gameDetails = _fetchGameDetails(widget.gameId);
    _gameScreenshots = _fetchGameScreenshots(widget.gameId);
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

  Future<GameDetails?> _fetchGameDetails(int gameId) async {
    try {
      bool result = await InternetConnection().hasInternetAccess;
      if (result) {
        return GameService().fetchGameDetails(gameId);
      } else {
        throw ('No internet connection');
      }
    } catch (e) {
      // throw ('Error fetching data   - me');
      return null;
    }
  }

  Future<List<Screenshot>?> _fetchGameScreenshots(int gameId) async {
    try {
      bool result = await InternetConnection().hasInternetAccess;
      if (result) {
        return GameService().fetchGameScreenshots(gameId);
      } else {
        throw ('No internet connection');
      }
    } catch (e) {
      // throw ('Error fetching data   - me2');
      return null;
    }
  }

  Future shareLink(String link, String message) async {
    await Share.share(link);
  }

  String sanitizeDescription(String description) {
    final unescape = HtmlUnescape();
    String decodedDescription = unescape.convert(description);

    decodedDescription =
        utf8.decode(decodedDescription.runes.toList(), allowMalformed: true);

    decodedDescription =
        decodedDescription.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    return _stripHtmlTags(decodedDescription);
  }

  String _stripHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(regex, '');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: FutureBuilder<GameDetails?>(
          future: _gameDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
              );
            } else if (snapshot.hasError) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Please check your internet connection"),
                backgroundColor: Colors.red.shade300,
              ));
              return const SizedBox.shrink();
            } else if (snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      "No data found",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Return to the previous page
                      },
                      child: const Text("Go back"),
                    ),
                  ],
                ),
              );
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
                                              .primary
                                              .withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(
                                              30), // Rounded corners
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(gameDetails.name,
                                          style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold)),
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
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.play_circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 24,
                                        ),
                                        onPressed: () async {
                                          if (!isInMyGames) {
                                            await myGames
                                                .addToMyGames(
                                                    gameDetails.id.toString())
                                                .then((onValue) =>
                                                    CustomSnackbar().show(
                                                        context,
                                                        'Added to My Games'));
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomePage(
                                                      title: 'GameOnConnect',
                                                    )),
                                          );
                                        },
                                      ),
                                      // child: Icon(
                                      //   Icons.play_circle,
                                      //   color: Theme.of(context)
                                      //       .colorScheme
                                      //       .primary,
                                      //   size: 24,
                                      // ),
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
                                          _badgeService.unlockExplorerComponent(
                                              "share_game");
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
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                            child: Text(
                                gameDetails.publisher.isNotEmpty
                                    ? gameDetails.publisher[0]['name'] ??
                                        'Unknown Publisher'
                                    : 'Unknown Publisher', //gameDetails.publisher[0]['name'],
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 115,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Text(
                                            'Rating: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          gameDetails.rating.toStringAsFixed(1),
                                          // gameDetails.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 115,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Text(
                                            'Metacritic: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          gameDetails.score.toString(),
                                          // gameDetails.score.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            indent: 0,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (isInWishlist) {
                                      await wishlist
                                          .removeFromWishlist(
                                              gameDetails.id.toString())
                                          .then((onValue) => CustomSnackbar()
                                              .show(context,
                                                  'Removed from Want to Play'));
                                    } else {
                                      await wishlist
                                          .addToWishlist(
                                              gameDetails.id.toString())
                                          .then(
                                            (onValue) => CustomSnackbar().show(
                                                context,
                                                'Added to Want to Play'),
                                          );
                                    }
                                    checkWishlistStatus();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<
                                            Color>(
                                        Theme.of(context).colorScheme.primary),
                                    padding: WidgetStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    ),
                                    elevation:
                                        WidgetStateProperty.all<double>(3),
                                    shape:
                                        WidgetStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                          isInWishlist
                                              ? Icons.remove
                                              : Icons.add,
                                          color: Colors.black),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        isInWishlist
                                            ? 'Want to Play'
                                            : 'Want to Play',
                                        // 'Add to wishlist',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (isInMyGames) {
                                      await myGames.removeFromMyGames(
                                          gameDetails.id.toString());
                                      CustomSnackbar().show(
                                          context, 'Removed from My Games');
                                    } else {
                                      await myGames.addToMyGames(
                                          gameDetails.id.toString());
                                      CustomSnackbar()
                                          .show(context, 'Added to My Games');
                                    }
                                    checkMyGamesStatus();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      Theme.of(context).colorScheme.surface,
                                    ),
                                    padding: WidgetStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    ),
                                    elevation:
                                        WidgetStateProperty.all<double>(3),
                                    shape:
                                        WidgetStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isInMyGames ? Icons.remove : Icons.add,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        isInMyGames ? 'My Games' : 'My Games',
                                        // 'Add to currently playing',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, -1),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                              child: CarouselNetworkImageWithPlaceholder(
                                imageUrl: gameDetails.backgroundImage,
                                width: 464,
                                height: 200,
                              ),
                            ),
                          ),
                          FutureBuilder<List<Screenshot>?>(
                            future: _gameScreenshots,
                            builder: (context, screenshotSnapshot) {
                              if (screenshotSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: LoadingAnimationWidget.halfTriangleDot(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 36,
                                  ),
                                );
                              } else if (screenshotSnapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading screenshots'));
                              } else if (!screenshotSnapshot.hasData ||
                                  screenshotSnapshot.data!.isEmpty ||
                                  snapshot.data == null) {
                                return const Center(
                                    child: Text('No screenshots available'));
                              } else {
                                final screenshots = screenshotSnapshot.data!;
                                return SizedBox(
                                  height: 60,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: screenshots.length,
                                    itemBuilder: (context, index) {
                                      if (index < 0 ||
                                          index >= screenshots.length) {
                                        return const Center(
                                            child: Text(
                                                'Invalid screenshot index'));
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 2, 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: InstaImageViewer(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  screenshots[index].image,
                                              placeholder: (context, url) => SizedBox(
                                                  width: 110, // Set the width of the images
                                                  height: 85, // Set the height of the images
                                                  child: Center(
                                                    child: SizedBox(
                                                      width:
                                                          30, // Adjust the size of the loader
                                                      height:
                                                          30, // Adjust the size of the loader
                                                      child:
                                                          LoadingAnimationWidget
                                                              .halfTriangleDot(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        size: 36,
                                                      ),
                                                    ),
                                                  )
                                                  // placeholder: (context, url) => const CircularProgressIndicator(),
                                                  // errorWidget: (context, url, error) => const Icon(Icons.error),
                                                  // width: 110,
                                                  // height: 85,
                                                  // fit: BoxFit.cover,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: InkWell(
                              onTap: () => launchUrlString(gameDetails.website),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.link,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Game website",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment(-1, -1),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                              child: Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ExpandableText(
                              sanitizeDescription(gameDetails.description),
                              expandText: 'See more',
                              collapseText: 'See less',
                              maxLines: 4,
                              linkColor: Theme.of(context).colorScheme.primary,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Platforms',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 12,
                                  ),
                                ), // This spacer will push the icons to the right edge
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: gameDetails.getPlatformIcons(
                                      context,
                                      Theme.of(context).colorScheme.secondary),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 0,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Developer',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  // gameDetails.developer,
                                  gameDetails.publisher.isNotEmpty
                                      ? gameDetails.publisher[0]['name'] ??
                                          'Unknown Publisher'
                                      : 'Unknown Publisher',
                                  // gameDetails.publisher[0]['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 0,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Publisher',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  gameDetails.publisher.isNotEmpty
                                      ? gameDetails.publisher[0]['name'] ??
                                          'Unknown Publisher'
                                      : 'Unknown Publisher',
                                  // gameDetails.publisher[0]['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 0,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Release Date',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 12),
                                ),
                                Text(
                                  gameDetails.released,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 0,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Genres',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 1,
                                  child: Wrap(
                                    spacing: 4.0,
                                    children: () {
                                      if (snapshot.data == null ||
                                          snapshot.data!.genres.isEmpty) {
                                        return [
                                          const Text('No genres available')
                                        ];
                                      }
                                      return snapshot.data!
                                          .getStyledGenres(context);
                                    }(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 0,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text("System requirements",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                          gameDetails.softwareRequirements != null
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Minimum",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Windows OS",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .minimumOS),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Processor",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .minimumProcessor),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Storage",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .minimumStorage),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Memory",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .minimumMemory),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Graphics",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .minimumGraphics),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Sound Card",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .minimumSoundCard),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Additional Notes",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .minimumAdditionalNotes),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                        child: VerticalDivider(
                                            thickness: 1,
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer),
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Recommended",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Windows OS",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .recommendedOS),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Processor",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .recommendedProcessor),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Storage",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .recommendedStorage),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Memory",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .recommendedMemory),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Graphics",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .recommendedGraphics),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Sound Card",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .recommendedSoundCard),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                            const Text("Additional Notes",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            Text(gameDetails
                                                .softwareRequirements!
                                                .recommendedAdditionalNotes),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                      "Check the game's website for the software requirements.",
                                      style: TextStyle(color: Colors.grey)),
                                ),
                          const Center(
                            child: Text('Credits: RAWG Video Games API'),
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
