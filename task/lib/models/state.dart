class States {
  String? name;
  List<String> cities;

  States({this.name, required this.cities});

  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      name: json['name'],
      cities: (json['cities'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['cities'] = cities;
    return json;
  }
}
