import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/services/game_library_S/my_games_service.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/services/stats_S/session_stats_service.dart';

class TimerService {
  static final TimerService _instance = TimerService._internal();
  static final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  DateTime _startTime = DateTime.timestamp();
  final SessionStatsService _sessionStatsService = SessionStatsService();
  String? _game;
  
  Future<List<GameDetails>>? _userGames;
  final MyGamesService _currentlyPlaying = MyGamesService();
  final GameService _gameService = GameService();
  final ProfileService _profileService = ProfileService();

  final ValueNotifier<String> elapsedTime = ValueNotifier<String>("00:00:00");

  factory TimerService() {
    return _instance;
  }

  TimerService._internal();

  void startTimer(Function onTick) {
    _profileService.setCurrentlyPlaying(_game!);
    _startTime = DateTime.timestamp();
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateElapsedTime();
      });
    }
  }

  void stopTimer() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      _updateElapsedTime();
    }
  }

  String _formatElapsedTime() {
    final int hours = _stopwatch.elapsed.inHours;
    final int minutes = (_stopwatch.elapsed.inMinutes % 60);
    final int seconds = (_stopwatch.elapsed.inSeconds % 60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _updateElapsedTime() {
    elapsedTime.value = _formatElapsedTime();
  }

  int getElapsedSeconds() {
    return _stopwatch.elapsed.inSeconds;
  }

  bool isRunning() {
    return _stopwatch.isRunning;
  }

  void resetTimer() {
    _stopwatch.reset();
    _updateElapsedTime();
  }

  Future<List<GameDetails>>? fetchUserGames() async {
    try {
      List<String> myGameIds = await _currentlyPlaying.getMyGames();

      Future<List<GameDetails>> gameDetailsFutures = Future.wait(
        myGameIds.map((id) => _gameService.fetchGameDetails(id)),
      );

      List<GameDetails> gameDetails = await gameDetailsFutures;

      _userGames = Future.value(gameDetails);

      return gameDetails;
    } catch (e) {
      rethrow;
    }
  }

  void setGame(String? game) {
    _game = game;
  }

  void addSession(String mood) async {
    if (_userGames != null && _game != null) {
      List<GameDetails> games = await _userGames!;
      GameDetails? selectedGame =
          games.firstWhere((game) => game.id.toString() == _game);
      List genres = selectedGame.genres;
      _sessionStatsService.addSession(
          getElapsedSeconds(), _game!, mood, genres, _startTime);
    }
  }
}
