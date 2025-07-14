class ContactUs {
  final String name;
  final String email;
  final String subject;
  final String message;
  final String? answer;
  final String? answerDate;
  final String? createdAt;
  final int userId;

  ContactUs({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    this.answer,
    this.answerDate,
    this.createdAt,
    required this.userId,
  });

  factory ContactUs.fromJson(Map<String, dynamic> json) => ContactUs(
    subject: json['subject'],
    message: json['message'],
    answer: json['answer'],
    answerDate: json['answer_date'],
    createdAt: json['created_at'],
    name: json['name'],
    email: json['email'],
    userId: json['user_id'] ?? 100,
  );

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'message': message,
    'answer': answer,
    'answer_date': answerDate,
    'created_at': createdAt,
    'name': name,
    'email': email,
    'user_id': userId,
  };
}
