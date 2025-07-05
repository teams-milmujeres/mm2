class Address {
  Address({
    required this.address,
    required this.physicalAddress,
    required this.unsafe,
    required this.mailingAddress,
  });

  String address;
  bool physicalAddress;
  bool unsafe;
  bool mailingAddress;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    address: json["address"],
    physicalAddress: json["physical_address"],
    unsafe: json["unsafe"],
    mailingAddress: json["mailing_address"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "physical_address": physicalAddress,
    "unsafe": unsafe,
    "mailing_address": mailingAddress,
  };
}
