import 'package:flutter/material.dart';

class Game {
  final int id;
  final String name;
  final String released;
  final List platforms;
  final String background_image;

  Game(
      {required this.id,
      required this.name,
      required this.released,
      required this.platforms,
      required this.background_image});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      released: json['released'],
      platforms: json['genres'],
      background_image: json['background_image'],
    );
  }
}