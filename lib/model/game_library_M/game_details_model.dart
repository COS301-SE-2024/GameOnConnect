import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SoftwareRequirements {
  String minimumOS;
  String minimumProcessor;
  String minimumMemory;
  String minimumGraphics;
  String minimumStorage;
  String minimumSoundCard;
  String minimumAdditionalNotes;

  String recommendedOS;
  String recommendedProcessor;
  String recommendedMemory;
  String recommendedGraphics;
  String recommendedStorage;
  String recommendedSoundCard;
  String recommendedAdditionalNotes;

  SoftwareRequirements({
    required this.minimumOS,
    required this.minimumProcessor,
    required this.minimumMemory,
    required this.minimumGraphics,
    required this.minimumStorage,
    required this.minimumSoundCard,
    required this.minimumAdditionalNotes,
    required this.recommendedOS,
    required this.recommendedProcessor,
    required this.recommendedMemory,
    required this.recommendedGraphics,
    required this.recommendedStorage,
    required this.recommendedSoundCard,
    required this.recommendedAdditionalNotes,
  });
}

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
  final List publisher;
  final double rating;
  final String website;
  List<Screenshot>? screenshots;
  SoftwareRequirements? softwareRequirements;

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
    this.softwareRequirements,
  });

  factory GameDetails.fromJson(Map<String, dynamic> json) {
    String? minimumRequirements;
    String? recommendedRequirements;

    for (var platform in json['platforms']) {
      if (platform['platform']['slug'] == 'pc' &&
          platform['requirements'] != null) {
        minimumRequirements = platform['requirements']['minimum'];
        recommendedRequirements = platform['requirements']['recommended'];
        break;
      }
    }

    SoftwareRequirements? softwareRequirements;
    if ((minimumRequirements != null && minimumRequirements.isNotEmpty) ||
        (recommendedRequirements != null &&
            recommendedRequirements.isNotEmpty)) {
      String requirementsString =
          'Minimum:\n$minimumRequirements\nRecommended:\n$recommendedRequirements';
      softwareRequirements = parseRequirements(requirementsString);
    }

    return GameDetails(
      id: json['id'],
      name: json['name'],
      developer: json['developers'] ?? [],
      description: json['description'] ?? "No description available.",
      released: json['released'] ?? "Unknown",
      platforms: json['platforms'],
      backgroundImage:
          json['background_image'] ?? "https://i.sstatic.net/y9DpT.jpg",
      score: json['metacritic'] ?? 0,
      genres: json['genres'],
      reviewsCount: json['reviews_count'] ?? 0,
      playtime: json['playtime'] ?? 0,
      screenshots: (json['screenshots'] as List<dynamic>?)
          ?.map((item) => Screenshot.fromJson(item))
          .toList(),
      publisher: json['publishers'] ?? [],
      rating: json['rating'] ?? 0.0,
      website: json['website'] ?? "No website available",
      softwareRequirements: softwareRequirements,
    );
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
        genresWidgets.add(
          Text(
            genre['name'],
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
            ),
            // overflow: TextOverflow.fade,
          ),
        );
        genresWidgets.add(const SizedBox(
          width: 10,
          // overflow: TextOverflow.visible,
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

class Screenshot {
  final String image;

  Screenshot({required this.image});

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      image: json['image'],
    );
  }
}

SoftwareRequirements parseRequirements(String requirementsString) {
  final osPattern = RegExp(r'OS: (.+?)(Processor|$)');
  final processorPattern = RegExp(r'Processor: (.+?)(Memory|$)');
  final memoryPattern = RegExp(r'Memory: (.+?)(Graphics|$)');
  final graphicsPattern = RegExp(r'Graphics: (.+?)(Storage|$)');
  final storagePattern = RegExp(r'Storage: (.+?)(Sound Card|$)');
  final soundCardPattern = RegExp(r'Sound Card: (.+?)(Additional Notes|$)');
  final additionalNotesPattern = RegExp(r'Additional Notes: (.+)$');

  final minimumOS =
      osPattern.firstMatch(requirementsString)?.group(1)?.trim() ?? '';
  final minimumProcessor =
      processorPattern.firstMatch(requirementsString)?.group(1)?.trim() ?? '';
  final minimumMemory =
      memoryPattern.firstMatch(requirementsString)?.group(1)?.trim() ?? '';
  final minimumGraphics =
      graphicsPattern.firstMatch(requirementsString)?.group(1)?.trim() ?? '';
  final minimumStorage =
      storagePattern.firstMatch(requirementsString)?.group(1)?.trim() ?? '';
  final minimumSoundCard =
      soundCardPattern.firstMatch(requirementsString)?.group(1)?.trim() ?? '';
  final minimumAdditionalNotes =
      additionalNotesPattern.firstMatch(requirementsString)?.group(1)?.trim() ??
          '';

  final recommendedSectionStart = requirementsString.indexOf('Recommended:');
  final recommendedString =
      requirementsString.substring(recommendedSectionStart);

  final recommendedOS =
      osPattern.firstMatch(recommendedString)?.group(1)?.trim() ?? '';
  final recommendedProcessor =
      processorPattern.firstMatch(recommendedString)?.group(1)?.trim() ?? '';
  final recommendedMemory =
      memoryPattern.firstMatch(recommendedString)?.group(1)?.trim() ?? '';
  final recommendedGraphics =
      graphicsPattern.firstMatch(recommendedString)?.group(1)?.trim() ?? '';
  final recommendedStorage =
      storagePattern.firstMatch(recommendedString)?.group(1)?.trim() ?? '';
  final recommendedSoundCard =
      soundCardPattern.firstMatch(recommendedString)?.group(1)?.trim() ?? '';
  final recommendedAdditionalNotes =
      additionalNotesPattern.firstMatch(recommendedString)?.group(1)?.trim() ??
          '';

  return SoftwareRequirements(
    minimumOS: minimumOS,
    minimumProcessor: minimumProcessor,
    minimumMemory: minimumMemory,
    minimumGraphics: minimumGraphics,
    minimumStorage: minimumStorage,
    minimumSoundCard: minimumSoundCard,
    minimumAdditionalNotes: minimumAdditionalNotes,
    recommendedOS: recommendedOS,
    recommendedProcessor: recommendedProcessor,
    recommendedMemory: recommendedMemory,
    recommendedGraphics: recommendedGraphics,
    recommendedStorage: recommendedStorage,
    recommendedSoundCard: recommendedSoundCard,
    recommendedAdditionalNotes: recommendedAdditionalNotes,
  );
}
