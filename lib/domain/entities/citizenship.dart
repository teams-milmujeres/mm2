class Citizenship {
  Citizenship({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Citizenship.fromJson(Map<String, dynamic> json) => Citizenship(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
