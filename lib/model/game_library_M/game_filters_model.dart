import 'dart:convert';
import 'package:http/http.dart' as http;

import 'game_filter_model.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    String? apikey = dotenv.env['RAWG_API_KEY'];

    final storeFilters = await _fetchFilters('https://api.rawg.io/api/stores?key=$apikey');
    final genreFilters = await _fetchFilters('https://api.rawg.io/api/genres?key=$apikey');
    final tagFilters = await _fetchFilters('https://api.rawg.io/api/tags?key=$apikey');
    final platformFilters = await _fetchFilters('https://api.rawg.io/api/platforms?key=$apikey');

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
