class Statee {
  Statee({
    required this.id,
    required this.abbrev,
    required this.name,
  });

  int id;
  String abbrev;
  String name;

  factory Statee.fromJson(Map<String, dynamic> json) => Statee(
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
