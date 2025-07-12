import 'package:milmujeres_app/domain/entities/country.dart';
import 'package:milmujeres_app/domain/entities/state.dart';

class Reference {
  Reference({
    required this.id,
    required this.organization,
    this.phone,
    this.email,
    this.address,
    this.website,
    this.contacts,
    this.city,
    required this.state,
    required this.country,
    required this.logo,
  });

  int id;
  String organization;
  String? phone;
  String? email;
  String? address;
  String? website;
  String? contacts;
  String? city;
  Statee state;
  Country country;
  bool logo;

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
    id: json['id'],
    organization: json['organization'] ?? '',
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
    website: json['website'],
    contacts: json['contacts'],
    city: json['city'],
    state: Statee.fromJson(json['state']),
    country: Country.fromJson(json['country']),
    logo: (json['logo'] ?? 0) == 1,
  );

  Map<dynamic, dynamic> toJson() => {
    id: 'id',
    organization: 'organization',
    phone: 'phone',
    email: 'email',
    address: 'address',
    website: 'website',
    contacts: 'contacts',
    city: 'city',
    state: 'state',
    country: 'country',
    logo: 'logo',
  };
}
