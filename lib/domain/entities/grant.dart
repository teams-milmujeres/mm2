class Grant {
  final int id;
  final String name;
  final String imageUrl;
  final bool activeInApp;
  final String website;
  final String telephone;
  final String email;

  Grant({
    required this.id,
    required this.name,
    required this.activeInApp,
    required this.imageUrl,
    required this.website,
    required this.telephone,
    required this.email,
  });

  factory Grant.fromJson(Map<String, dynamic> json) {
    return Grant(
      id: json['id'],
      name: json['name'],
      activeInApp: json['active_in_app'],
      imageUrl: json['image'] ?? '',
      website: json['website'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
