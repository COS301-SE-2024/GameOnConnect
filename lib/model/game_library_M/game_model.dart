// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Game {
  final int id;
  final String name;
  final String released;
  final List platforms;
  final String backgroundImage;
  final int score;
  final List genres;
  final int reviewsCount;

  Game(
      {required this.id,
      required this.name,
      required this.released,
      required this.platforms,
      required this.backgroundImage,
      required this.score,
      required this.genres,
      required this.reviewsCount});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
        id: json['id'],
        name: json['name'],
        released: json['released'] ?? "Unknown",
        platforms: json['platforms'],
        backgroundImage:
            json['background_image'] ?? "https://i.sstatic.net/y9DpT.jpg",
        score: json['metacritic'] ?? 0,
        genres: json['genres'],
        reviewsCount: json['reviews_count'] ?? 0);
  }

  List<Widget> getPlatformIcons(BuildContext context, Color color) {
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
          color: color,
        ));
        icons.add(const SizedBox(
          width: 10,
        ));
      } else if (platform.toString().toLowerCase().contains('xbox') && !xbox) {
        xbox = true;
        icons.add(Icon(
          FontAwesomeIcons.xbox,
          color: color,
        ));
        icons.add(const SizedBox(
          width: 10,
        ));
      } else if (platform.toString().toLowerCase().contains('playstation') &&
          !playstation) {
        playstation = true;
        icons.add(Icon(
          FontAwesomeIcons.playstation,
          color: color,
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
              decorationColor: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ));
        genresWidgets.add(const SizedBox(
          width: 5,
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
