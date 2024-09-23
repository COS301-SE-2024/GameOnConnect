import 'package:flutter/foundation.dart';

class ScoreManager {
  static final ScoreManager _instance = ScoreManager._internal(); 
  final ValueNotifier<int> _scoreNotifier = ValueNotifier<int>(0); //this notifies listeners when the score changes

  factory ScoreManager() {
    return _instance; //creates a new instance of the ScoreManager class
  }

  ScoreManager._internal();

  ValueNotifier<int> get scoreNotifier => _scoreNotifier;

  int get score => _scoreNotifier.value; //returns the current score

  void increaseScore(int points) {
    _scoreNotifier.value += points; //increases the score by the points of the fruit
  }

  void resetScore() {
    _scoreNotifier.value = 0; //reset the score to 0
  }
}