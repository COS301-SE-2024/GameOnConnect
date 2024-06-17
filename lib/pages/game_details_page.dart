// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class GameDetailsPage extends StatelessWidget {
  final Map<String, dynamic> mockGameData = {
    'title': 'Fortnite',
    'developer': 'Epic Games',
    'ratings': '457.2 M',
    'score': 96,
    'attribute': '64%',
    'about': 'Fortnite is a third-person shooter game where up to 100 players compete to be the last person or team standing. You can compete alone or in a team of up to four. You progress through the game by exploring the island, collecting weapons, building fortifications and engaging in combat with other players.',
    'platforms': 'Platforms',
    'publisher': 'Epic Games',
    'releaseDate': '2017/09/26',
    'genres': ['Action', 'Battle Royale', 'Shooter'],
    'systemRequirements': {
      'minimum': {
        'OS': 'Windows 10 - 64-Bit',
        'processor': 'Intel Core i5-6600K / AMD Ryzen 5 3600 3.7GHz',
        'storage': '100 GB',
        'graphics': 'NVIDIA GeForce GTX 1050 Ti / AMD Radeon RX 570 4GB',
      },
      'recommended': {
        'OS': 'Windows 10 - 64-Bit',
        'processor': 'Intel Core i7-8700 / AMD Ryzen 7 2700X 3.7GHz',
        'storage': '100 GB',
        'graphics': 'NVIDIA GeForce GTX 1660 / AMD Radeon RX 580 XT',
      },
    },
    'storeLinks': [
      {'name': 'STEAM', 'icon': Icons.store, 'url': ''},
      {'name': 'EPIC GAMES', 'icon': Icons.store, 'url': ''},
      {'name': 'PS STORE', 'icon': Icons.store, 'url': ''},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Specific Game - Dark'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  'https://cdn2.unrealengine.com/fortnite-chapter-2-keyart-1920x1080-1920x1080-dbb72ac1f733.jpg',
                  height: 200,
                ),
              ),
              SizedBox(height: 8),
              Text(
                mockGameData['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                mockGameData['developer'],
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('RATINGS', mockGameData['ratings']),
                  _buildStatCard('SCORE', mockGameData['score'].toString()),
                  _buildStatCard('ATTRIBUTE', mockGameData['attribute']),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'About',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Image.network(
                'https://cdn2.unrealengine.com/fortnite-chapter-2-keyart-1920x1080-1920x1080-dbb72ac1f733.jpg',
                height: 100,
              ),
              SizedBox(height: 8),
              Text(
                mockGameData['about'],
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'Platforms',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.desktop_windows, color: Colors.grey),
                  SizedBox(width: 8),
                  Icon(Icons.phone_iphone, color: Colors.grey),
                  SizedBox(width: 8),
                  Icon(Icons.videogame_asset, color: Colors.grey),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Developer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                mockGameData['developer'],
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'Publisher',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                mockGameData['publisher'],
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'Release date',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                mockGameData['releaseDate'],
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'Genres',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: mockGameData['genres']
                    .map<Widget>((genre) => Chip(
                          label: Text(genre),
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(color: Colors.white),
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Add to wishlist'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Text('Add to currently playing'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'System requirements',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSystemRequirementsCard('Minimum', mockGameData['systemRequirements']['minimum']),
                  _buildSystemRequirementsCard('Recommended', mockGameData['systemRequirements']['recommended']),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Stores selling the game',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: mockGameData['storeLinks']
                    .map<Widget>((store) => _buildStoreLink(store))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSystemRequirementsCard(String type, Map<String, String> requirements) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: requirements.entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildStoreLink(Map<String, dynamic> store) {
    return Column(
      children: [
        Icon(store['icon'], color: Colors.green, size: 40),
        SizedBox(height: 4),
        Text(
          store['name'],
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
