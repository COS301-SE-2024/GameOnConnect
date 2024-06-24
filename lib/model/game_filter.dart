class Filter {
  String value;
  String id;

  Filter({
    required this.value,
    required this.id
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      value: json['name'],
      id: json['id'].toString()
    );
  }
}