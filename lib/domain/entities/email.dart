class Email {
  Email({
    required this.email,
    required this.note,
  });

  dynamic email;
  dynamic note;

  factory Email.fromJson(Map<dynamic, dynamic> json) => Email(
    email: json["email"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "note": note,
  };
}