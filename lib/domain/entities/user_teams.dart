class Userteams {
  final int id;
  final String name;
  final String avatar;

  Userteams({required this.id, required this.name, required this.avatar});

  factory Userteams.fromJson(Map<String, dynamic> json) {
    return Userteams(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
    );
  }
}
