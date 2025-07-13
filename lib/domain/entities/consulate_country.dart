class ConsulateCountry {
  ConsulateCountry({
    required this.id,
    required this.abbrev,
    required this.name,
  });

  int id;
  String abbrev;
  String name;

  factory ConsulateCountry.fromJson(Map<String, dynamic> json) =>
      ConsulateCountry(
        id: json["id"],
        abbrev: json["abbrev"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {"id": id, "abbrev": abbrev, "name": name};
}
