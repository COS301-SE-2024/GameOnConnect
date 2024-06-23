import 'dart:convert';
import 'package:http/http.dart' as http;

import 'game_filter.dart'; 

class FilterList {
  List<Filter> storeFilters;
  List<Filter> genreFilters;
  List<Filter> tagFilters;
  List<Filter> platformFilters;

  FilterList({
    required this.storeFilters,
    required this.genreFilters,
    required this.tagFilters,
    required this.platformFilters,
  });

  static FilterList? _instance;

  static Future<FilterList> getInstance() async {
    _instance ??= await _createFilterList();
    return _instance!;
  }

  static Future<FilterList> _createFilterList() async {
    final storeFilters = await _fetchFilters('https://api.rawg.io/api/stores?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    final genreFilters = await _fetchFilters('https://api.rawg.io/api/genres?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    final tagFilters = await _fetchFilters('https://api.rawg.io/api/tags?key=b8d81a8e79074f1eb5c9961a9ffacee6');
    final platformFilters = await _fetchFilters('https://api.rawg.io/api/platforms?key=b8d81a8e79074f1eb5c9961a9ffacee6');

    return FilterList(
      storeFilters: storeFilters,
      genreFilters: genreFilters,
      tagFilters: tagFilters,
      platformFilters: platformFilters,
    );
  }

  static Future<List<Filter>> _fetchFilters(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData['results'] as List).map((filterJson) => Filter.fromJson(filterJson)).toList();
    } else {
      throw Exception('Failed to load data from $url');
    }
  }
}
