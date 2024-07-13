import 'package:flutter/material.dart';

class GameDetails {
  final int id;
  final String name;
  final List developer;
  final String description;
  final String released;
  final List platforms;
  final String backgroundImage;
  final int score;
  final List genres;
  final int reviewsCount;
  final int playtime;
  final List screenshots;
  final List publisher;
  final double rating;
  final String website;

  GameDetails({
    required this.id,
    required this.name,
    required this.developer,
    required this.description,
    required this.released,
    required this.platforms,
    required this.backgroundImage,
    required this.score,
    required this.genres,
    required this.reviewsCount,
    required this.playtime,
    required this.screenshots,
    required this.publisher,
    required this.rating,
    required this.website,
  });

  factory GameDetails.fromJson(Map<String, dynamic> json) {
    return GameDetails(
      id: json['id'],
      name: json['name'],
      developer: json['developers'] ?? [],
      description: json['description'] ?? "No description available.",
      released: json['released'] ?? "Unknown",
      platforms: json['platforms'],
      backgroundImage: json['background_image'] ?? "https://i.sstatic.net/y9DpT.jpg",
      score: json['metacritic'] ?? 0,
      genres: json['genres'],
      reviewsCount: json['reviews_count'] ?? 0,
      playtime: json['playtime'] ?? 0,
      screenshots: json['screenshots'] ?? [],
      publisher: json['publishers'] ?? [],
      rating: json['rating'] ?? 0.0,
      website: json['website'] ?? "No website available",
    );
  }

  List<Widget> getPlatformIcons(BuildContext context) {
    List<Widget> icons = [];
    bool pc, xbox, playstation;
    pc = false;
    xbox = false;
    playstation = false;

    for (var platform in platforms) {
      if (platform.toString().toLowerCase().contains('pc') && !pc) {
        pc = true;
        icons.add(Icon(
          Icons.computer,
          color: Theme.of(context).colorScheme.secondary,
        ));
        icons.add(const SizedBox(
          width: 10,
        ));
      } else if (platform.toString().toLowerCase().contains('xbox') && !xbox) {
        xbox = true;
        icons.add(Icon(
          Icons.gamepad,
          color: Theme.of(context).colorScheme.secondary,
        ));
        icons.add(const SizedBox(
          width: 10,
        ));
      } else if (platform.toString().toLowerCase().contains('playstation') &&
          !playstation) {
        playstation = true;
        icons.add(Icon(
          Icons.videogame_asset,
          color: Theme.of(context).colorScheme.secondary,
        ));
        icons.add(const SizedBox(
          width: 10,
        ));
      }
    }

    return icons;
  }

  List<Widget> getStyledGenres(BuildContext context) {
    List<Widget> genresWidgets = [];

    if (genres.isNotEmpty) {
      for (var genre in genres) {
        genresWidgets.add(Expanded(
          child: Text(
            genre['name'],
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.secondary,
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ));
        genresWidgets.add(const SizedBox(
          width: 10,
        ));
      }
    } else {
      return [
        Text(
          "None",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
          overflow: TextOverflow.ellipsis,
        )
      ];
    }
    return genresWidgets;
  }
}
