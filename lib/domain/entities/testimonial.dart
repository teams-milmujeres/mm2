class Testimonial {
  final String name;
  final String location;
  final String testimonial;
  final int stars;

  Testimonial({
    required this.name,
    required this.location,
    required this.testimonial,
    required this.stars,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      name: json['name'],
      location: json['location'],
      testimonial: json['testimonial'],
      stars: json['stars'],
    );
  }

  factory Testimonial.fromMap(Map<String, dynamic> map) {
    return Testimonial(
      name: map['name'],
      location: map['location'],
      testimonial: map['testimonial'],
      stars: map['stars'],
    );
  }
}
