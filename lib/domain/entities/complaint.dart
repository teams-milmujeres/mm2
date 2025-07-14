class Complaint {
  final String subject;
  final String message;
  final String? answer;
  final String? answerDate;
  final String? createdAt;
  final int userId;

  Complaint({
    required this.subject,
    required this.message,
    this.answer,
    this.answerDate,
    this.createdAt,
    required this.userId,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
    subject: json['subject'],
    message: json['message'],
    answer: json['answer'],
    answerDate: json['answer_date'],
    createdAt: json['created_at'],
    userId: json['user_id'] ?? 100,
  );

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'message': message,
    'answer': answer,
    'answer_date': answerDate,
    'created_at': createdAt,
    'user_id': userId,
  };
}
