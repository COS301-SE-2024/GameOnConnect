import 'package:flutter_test/flutter_test.dart';
import 'package:gameonconnect/model/game_library_M/game_model.dart';
import 'package:gameonconnect/view/pages/game_library/game_details_page.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/game_library/game_library_page.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';

class MockGameService extends Mock implements GameService {}

void main() {
  group('GameLibrary Widget Tests', () {
    late MockGameService mockGameService;

    setUp(() {
      mockGameService = MockGameService();
    });

    testWidgets('Initial state loads games', (WidgetTester tester) async {
      // Arrange: Mock the data returned by GameService
      when(mockGameService.fetchGames(1,
              sortValue: '', searchQuery: '', filterString: ''))
          .thenAnswer((_) async => [Game(id: 1, name: 'Test Game', backgroundImage: '', released: '', score: 90, platforms: [], genres: [], reviewsCount: 0)]);
          
      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: GameLibrary(gameService: mockGameService),
        ),
      );

      // Assert: Verify that _loadGames was called and games are fetched
      verify(mockGameService.fetchGames(1,
              sortValue: '', searchQuery: '', filterString: ''))
          .called(1);
    });

    testWidgets('Search updates games list', (WidgetTester tester) async {
      // Arrange: Mock GameService to return different results
      when(mockGameService.fetchGames(1,
              sortValue: '', searchQuery: 'test', filterString: ''))
          .thenAnswer((_) async => [Game(id: 1, name: 'Test Game', backgroundImage: '', released: '', score: 90, platforms: [], genres: [], reviewsCount: 0)]);

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: GameLibrary(gameService: mockGameService),
        ),
      );

      // Simulate typing in the search field
      final searchField = find.byKey(const Key('searchTextField'));
      await tester.enterText(searchField, 'test');
      await tester.pump();

      // Assert: Verify that fetchGames was called with the search query
      verify(mockGameService.fetchGames(1,
              sortValue: '', searchQuery: 'test', filterString: ''))
          .called(1);
    });

    testWidgets('Sort games by name', (WidgetTester tester) async {
      // Arrange: Mock GameService to return sorted results
      when(mockGameService.fetchGames(1,
              sortValue: anyNamed('name'), searchQuery: anyNamed('search'), filterString: anyNamed('filter')))
          .thenAnswer((_) async => [Game(id: 1, name: 'Test Game', backgroundImage: '', released: '', score: 90, platforms: [], genres: [], reviewsCount: 0)]);

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: GameLibrary(gameService: mockGameService),
        ),
      );

      // Tap on the sort button
      final sortButton = find.text('Sort');
      await tester.tap(sortButton);
      await tester.pumpAndSettle(); // Wait for the dialog to appear

      // Select 'Name' in the dialog
      final nameSortOption = find.text('Name');
      await tester.tap(nameSortOption);
      await tester.pump();

      // Assert: Verify that fetchGames was called with the sort value 'name'
      verify(mockGameService.fetchGames(1,
              sortValue: 'name', searchQuery: '', filterString: ''))
          .called(1);
    });

    testWidgets('Filter games by platform', (WidgetTester tester) async {
      // Arrange: Mock GameService to return filtered results
      when(mockGameService.fetchGames(1,
              sortValue: '', searchQuery: '', filterString: 'PC'))
          .thenAnswer((_) async => [Game(id: 1, name: 'Test Game', backgroundImage: '', released: '', score: 90, platforms: [], genres: [], reviewsCount: 0)]);

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: GameLibrary(gameService: mockGameService),
        ),
      );

      // Navigate to the Filter page
      final filterButton = find.text('Filter');
      await tester.tap(filterButton);
      await tester.pumpAndSettle(); // Wait for the Filter page to appear

      // Select 'PC' as the filter option
      final pcFilterOption = find.text('PC');
      await tester.tap(pcFilterOption);
      await tester.pump();

      // Assert: Verify that fetchGames was called with the filter value 'PC'
      verify(mockGameService.fetchGames(1,
              sortValue: '', searchQuery: '', filterString: 'PC'))
          .called(1);
    });

    testWidgets('Navigate to GameDetailsPage', (WidgetTester tester) async {
      // Arrange: Mock GameService to return a game
      final game = Game(
          id: 1,
          name: 'Test Game',
          backgroundImage: '',
          released: '2020',
          platforms: [],
          score: 0,
          genres: [],
          reviewsCount: 0);
      when(mockGameService.fetchGames(1,
              sortValue: '', searchQuery: '', filterString: ''))
          .thenAnswer((_) async => [game]);

      // Act: Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: GameLibrary(gameService: mockGameService),
        ),
      );
      await tester.pumpAndSettle(); // Wait for the game list to be populated

      // Tap on the first game in the list
      final gameTile = find.text('Test Game');
      await tester.tap(gameTile);
      await tester.pumpAndSettle(); // Wait for navigation

      // Assert: Verify that the GameDetailsPage is displayed
      expect(find.byType(GameDetailsPage), findsOneWidget);
    });
  });
}
