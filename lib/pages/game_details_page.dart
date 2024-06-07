import 'package:flutter/material.dart';

class GameDetailsPage extends StatelessWidget {
  const GameDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        title: Text('Specific Game', style: textTheme.headlineSmall?.copyWith(color: colorScheme.onBackground)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/fortnite.jpg', // Make sure to add this image in your assets
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 5; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.circle, color: colorScheme.onBackground, size: 8),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Fortnite', style: textTheme.headlineMedium?.copyWith(color: colorScheme.onBackground)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text('Currently Playing', style: TextStyle(color: colorScheme.onPrimary)),
                    backgroundColor: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text('Share', style: TextStyle(color: colorScheme.onPrimary)),
                    backgroundColor: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Icon(Icons.favorite_border, color: colorScheme.onPrimary),
                    backgroundColor: colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('About', style: textTheme.headlineSmall?.copyWith(color: colorScheme.onBackground)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: [
                  Chip(
                    label: Text('Battle royale', style: TextStyle(color: colorScheme.onSurface)),
                    backgroundColor: colorScheme.surface,
                  ),
                  Chip(
                    label: Text('FPS', style: TextStyle(color: colorScheme.onSurface)),
                    backgroundColor: colorScheme.surface,
                  ),
                  Chip(
                    label: Text('Multiplayer', style: TextStyle(color: colorScheme.onSurface)),
                    backgroundColor: colorScheme.surface,
                  ),
                  Chip(
                    label: Text('Adventure', style: TextStyle(color: colorScheme.onSurface)),
                    backgroundColor: colorScheme.surface,
                  ),
                  Chip(
                    label: Text('Action', style: TextStyle(color: colorScheme.onSurface)),
                    backgroundColor: colorScheme.surface,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Fortnite Battle Royale is the completely free 100-player PvP mode in Fortnite. One giant map. A battle bus. Fortnite building skills and destructible environments combined with intense PvP combat. The last one standing wins.',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.computer, color: colorScheme.onBackground),
                  const SizedBox(width: 8),
                  Icon(Icons.phone_android, color: colorScheme.onBackground),
                  const SizedBox(width: 8),
                  Icon(Icons.videogame_asset, color: colorScheme.onBackground),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // Handle shop button press
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary,
                  backgroundColor: colorScheme.primary,
                ),
                child: Text('Shop', style: TextStyle(color: colorScheme.onPrimary)),
              ),
              const SizedBox(height: 16),
              Text('System Requirements', style: textTheme.headlineSmall?.copyWith(color: colorScheme.onBackground)),
              const SizedBox(height: 8),
              Table(
                border: TableBorder.all(color: colorScheme.onSurface),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Minimum', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Recommended', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'OS: Windows 10 64-bit version\nCPU: Core i3-3225 3.3 GHz\nMemory: 4GB\nGPU: Intel HD 4000 on PC; AMD Radeon Vega 8',
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'OS: Windows 10 64-bit\nCPU: Intel i7-8700; AMD Ryzen 7 3700X or equivalent\nMemory: 8GB or higher\nGPU: Nvidia GTX 1080; AMD Radeon RX 480 or equivalent GPU',
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground),
                      ),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 16),
              Text('Reviews', style: textTheme.headlineSmall?.copyWith(color: colorScheme.onBackground)),
              const SizedBox(height: 8),
              _buildReview('franco_dreyer', 'Fortnite offers an incredibly fun and dynamic gaming experience with its vibrant graphics and engaging gameplay.', colorScheme),
              const SizedBox(height: 8),
              _buildReview('piery_xdl', 'While Fortnite has impressive graphics and a large player base, the frequent updates and changes can sometimes disrupt the gaming experience.', colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReview(String username, String review, ColorScheme colorScheme) {
    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: Text(username[0].toUpperCase(), style: TextStyle(color: colorScheme.onPrimary)),
                ),
                const SizedBox(width: 8),
                Text(username, style: TextStyle(color: colorScheme.onBackground)),
              ],
            ),
            const SizedBox(height: 8),
            Text(review, style: TextStyle(color: colorScheme.onBackground)),
          ],
        ),
      ),
    );
  }
}
