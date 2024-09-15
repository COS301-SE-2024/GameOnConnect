import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/GameyCon/components/leavebutton.dart';
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
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
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    child: const Text('Start Game'),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 10,
            left: 20,
            child: LeaveButton(),
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
