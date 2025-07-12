class Country {
  Country({
    required this.id,
    required this.abbrev,
    required this.name,
  });

  int id;
  String abbrev;
  String name;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    abbrev: json["abbrev"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "abbrev": abbrev,
    "name": name,
  };
}
