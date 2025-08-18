import 'package:mm/domain/entities/country.dart';
import 'package:mm/domain/entities/state.dart';

class Alliance {
  Alliance({
    required this.id,
    required this.organization,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.contact,
    this.services,
    this.city,
    required this.state,
    required this.country,
    required this.logo,
  });

  int id;
  String organization;
  String? address;
  String? phone;
  String? email;
  String? website;
  String? contact;
  String? services;
  String? city;
  Statee state;
  Country country;
  bool logo;

  factory Alliance.fromJson(Map<String, dynamic> json) => Alliance(
    id: json['id'],
    organization: json['organization'] ?? '',
    address: json['address'],
    phone: json['phone'],
    email: json['email'],
    website: json['website'],
    contact: json['contact'],
    services: json['services'],
    city: json['city'],
    state: Statee.fromJson(json['state']),
    country: Country.fromJson(json['country']),
    logo: (json['logo'] ?? 0) == 1,
  );

  Map<dynamic, dynamic> toJson() => {
    id: 'id',
    organization: 'organization',
    address: 'address',
    email: 'email',
    phone: 'phone',
    website: 'website',
    contact: 'contact',
    services: 'services',
    city: 'city',
    state: 'state',
    country: 'country',
    logo: 'logo',
  };
}
