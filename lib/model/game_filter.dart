class Filter {
  String value;
  String slug;

  Filter({
    required this.value,
    required this.slug
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      value: json['name'],
      slug: json['slug']
    );
  }
}