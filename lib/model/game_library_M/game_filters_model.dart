import 'game_filter_model.dart'; 

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
}
