import 'package:flutter/material.dart';

class Game {
  final int id;
  final String name;
  final String released;
  final List platforms;
  final String background_image;
  final int score;
  final List genres;

  Game(
      {required this.id,
      required this.name,
      required this.released,
      required this.platforms,
      required this.background_image,
      required this.score,
      required this.genres});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      released: json['released'],
      platforms: json['platforms'],
      background_image: json['background_image'],
      score: json['metacritic'] ?? 0,
      genres: json['genres'],
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
          color: Theme.of(context).colorScheme.primary,
        ));
        icons.add(SizedBox(
          width: 10,
        ));
      } else if (platform.toString().toLowerCase().contains('xbox') && !xbox) {
        xbox = true;
        icons.add(Icon(
          Icons.gamepad,
          color: Theme.of(context).colorScheme.primary,
        ));
        icons.add(SizedBox(
          width: 10,
        ));
      } else if (platform.toString().toLowerCase().contains('playstation') &&
          !playstation) {
        playstation = true;
        icons.add(Icon(
          Icons.videogame_asset,
          color: Theme.of(context).colorScheme.primary,
        ));
        icons.add(SizedBox(
          width: 10,
        ));
      }
    }

    return icons;
  }

  List<Widget> getStyledGenres(BuildContext context) {
    List<Widget> genresWidgets = [];

    if (genres.isNotEmpty && genres != null) {
      for (var genre in genres) {
        genresWidgets.add(Text(genre['name'],
            style: TextStyle(
              decoration: TextDecoration.underline, decorationColor: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            )));
        genresWidgets.add(SizedBox(
          width: 15,
        ));
      }
    } else {
      return [];
    }
    return genresWidgets;
  }
}
