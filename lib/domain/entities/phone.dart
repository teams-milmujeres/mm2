class Phone {
  Phone({
    required this.phone,
    required this.unsafe,
  });

  String phone;
  bool unsafe;

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
    phone: json["phone"],
    unsafe: json["unsafe"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "unsafe": unsafe,
  };
}