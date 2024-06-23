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
}
