import 'package:milmujeres_app/domain/entities/country.dart';
import 'package:milmujeres_app/domain/entities/state.dart';

class Consulate {
  Consulate({
    required this.id,
    required this.consulate,
    this.email,
    this.contacts,
    this.phone,
    this.responsable,
    this.city,
    required this.state,
    required this.country,
    required this.logo,
  });

  int id;
  String consulate;
  String? email;
  String? contacts;
  String? phone;
  String? responsable;
  String? city;
  Statee state;
  Country country;
  bool logo;

  factory Consulate.fromJson(Map<String, dynamic> json) => Consulate(
    id: json['id'],
    consulate: json['consulate'] ?? '',
    email: json['email'],
    contacts: json['contacts'],
    phone: json['phone'],
    responsable: json['responsable'],
    city: json['city'],
    state: Statee.fromJson(json['state']),
    country: Country.fromJson(json['country']),
    logo: (json['logo'] ?? 0) == 1,
  );

  Map<dynamic, dynamic> toJson() => {
    id: 'id',
    consulate: 'consulate',
    email: 'email',
    contacts: 'contacts',
    phone: 'phone',
    responsable: 'responsable',
    city: 'city',
    state: 'state',
    country: 'country',
    logo: 'logo',
  };
}
