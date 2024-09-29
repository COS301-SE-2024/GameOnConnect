import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/view/pages/GameyCon/gameycon_page.dart';

class LoadingGameyConPage extends StatefulWidget {
  const LoadingGameyConPage({super.key});

  @override
  State<LoadingGameyConPage> createState() => _LoadingGameyConPageState();
}

class _LoadingGameyConPageState extends State<LoadingGameyConPage> {
  int selectedCharacterIndex = -1;

  final List<String> characterSprites = [
    'Ninja Frog',
    'Pink Man',
    'Virtual Guy',
    'Mask Dude',
  ];

  void selectCharacter(int index) {
    setState(() {
      selectedCharacterIndex = index;
    });
  }

  void startGame() {
    if (selectedCharacterIndex != -1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameyConPage(
            selectedCharacter: characterSprites[selectedCharacterIndex],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/icons/GameOnConnect_Logo_Transparent_White.png'
                      : 'assets/icons/GameOnConnect_Logo_Transparent.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome to GameyCon!",
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'ThaleahFat',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select a character',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'ThaleahFat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: characterSprites.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => selectCharacter(index),
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedCharacterIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: SpriteAnimationWidget(
                            character: characterSprites[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed: startGame,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: const Text('Start Game'),
                  ),
                ),
                // const SizedBox(
                //   height: 225,
                // ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Credits: Spellthorn (Youtube)'),
                ),

              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 30),
              onPressed: () {
                Navigator.pop(context); 
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SpriteAnimationWidget extends StatelessWidget {
  final String character;

  const SpriteAnimationWidget({required this.character, super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: SpriteAnimationGame(character: character),
    );
  }
}

class SpriteAnimationGame extends FlameGame {
  final String character;

  SpriteAnimationGame({required this.character});

  @override
  Future<void> onLoad() async {
    final animation = await _loadAnimation(character);
    add(
      SpriteAnimationComponent(
        animation: animation,
        size: Vector2(50, 50),
        position: size / 2 - Vector2(25, 25),
      ),
    );
  }

  Future<SpriteAnimation> _loadAnimation(String character) async {
    final spriteSheet =
        await images.load('Main Characters/$character/Idle (32x32).png');
    return SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
      ),
    );
  }
}