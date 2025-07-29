class Country {
  Country({required this.id, required this.abbrev, required this.name});

  int id;
  String abbrev;
  String name;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    abbrev: json["abbrev"]?.toString() ?? 'N/A',
    name: json["name"]?.toString() ?? 'N/A',
  );

  Map<String, dynamic> toJson() => {"id": id, "abbrev": abbrev, "name": name};
}
