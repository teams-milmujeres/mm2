class Rating {
  final int clientId;
  final bool isRating;
  final int rating;
  final String comment;

  Rating({
    required this.clientId,
    required this.rating,
    required this.comment,
    required this.isRating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      clientId: json['client_id'] ?? 0,
      isRating: json['rating_service'] == true || json['rating_service'] == 1,
      rating: json['rating_number'] ?? 0,
      comment: json['rating_comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'rating_number': rating,
      'rating_comment': comment,
      'rating_service': isRating,
    };
  }
}
