import 'dart:convert';
import 'phone.dart';
import 'address.dart';
import 'email.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    this.lastName = '',
    required this.firstName,
    this.locale,
    this.middleName,
    this.userName,
    this.dob,
    this.emails = const [],
    this.addresses = const [],
    this.phones = const [],
    this.email = '',
    this.phone,
    this.avatar,
    this.countryOfBirthId,
    this.citizenshipId,
    this.howMeet,
    this.signatureUploadDocuments,
    this.signatureUploadDocumentsVersion,
  });

  int id;
  String lastName;
  String firstName;
  String? locale;
  String? middleName;
  String? userName;
  String? phone;
  String? avatar;
  DateTime? dob;
  List<Email> emails;
  List<Address> addresses;
  List<Phone> phones;
  String email;
  int? countryOfBirthId;
  int? citizenshipId;

  String? howMeet;
  bool? signatureUploadDocuments;
  double? signatureUploadDocumentsVersion;

  factory User.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      final str = value.toString().replaceAll(',', '.');
      return double.tryParse(str);
    }

    return User(
      id: json["id"],
      lastName: json["lastname"] ?? '',
      firstName: json["firstname"],
      locale: json["locale"],
      middleName: json["middlename"],
      dob: json["dob"] != null ? DateTime.tryParse(json["dob"]) : null,
      userName: json["username"],
      emails:
          json["emails"] != null
              ? List<Email>.from(json["emails"].map((x) => Email.fromJson(x)))
              : [],
      addresses:
          json["address"] != null
              ? List<Address>.from(
                json["address"].map((x) => Address.fromJson(x)),
              )
              : [],
      phones:
          json["phones"] != null
              ? List<Phone>.from(json["phones"].map((x) => Phone.fromJson(x)))
              : [],
      email: json["email"] ?? '',
      phone: json["phone"] ?? '',
      avatar: json["avatar"],
      countryOfBirthId:
          json["country_of_birth_id"] != null
              ? int.tryParse(json["country_of_birth_id"].toString())
              : null,
      citizenshipId:
          json["citizenship_id"] != null
              ? int.tryParse(json["citizenship_id"].toString())
              : null,
      howMeet: json["how_meet"],
      signatureUploadDocuments: json["signature_upload_documents"] ?? false,
      signatureUploadDocumentsVersion: parseDouble(
        json["signature_upload_documents_version"],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "lastname": lastName,
    "firstname": firstName,
    "middlename": middleName,
    "locale": locale,
    "dob":
        dob != null
            ? "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}"
            : null,
    "emails": emails.map((x) => x.toJson()).toList(),
    "address": addresses.map((x) => x.toJson()).toList(),
    "phones": phones.map((x) => x.toJson()).toList(),
    "email": email,
    "phone": phone,
    "avatar": avatar,
    "country_of_birth_id": countryOfBirthId,
    "citizenship_id": citizenshipId,
    "how_meet": howMeet,
    "signature_upload_documents": signatureUploadDocuments,
    "signature_upload_documents_version": signatureUploadDocumentsVersion,
  };
}
