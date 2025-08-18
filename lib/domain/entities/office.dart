import 'package:mm/domain/entities/alliance.dart';
import 'package:mm/domain/entities/consulate.dart';
import 'package:mm/domain/entities/reference.dart';

class Office {
  Office({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
    required this.poBoxForUscis,
    this.mmFax,
    this.cityEmail,
    this.officeDirector,
    this.officeDirectorEmail,
    this.urlGoogleMaps,
    this.imageUrl,
    this.references = const [],
    this.alliances = const [],
    this.consulates = const [],

    this.lat,
    this.lon,
  });

  final int id;
  final String name;
  final String city;
  final String address;
  final String phone;
  final String poBoxForUscis;
  final String? mmFax;
  final String? cityEmail;
  final String? officeDirector;
  final String? officeDirectorEmail;
  final String? urlGoogleMaps;
  final String? imageUrl;

  final double? lat;
  final double? lon;

  final List<Reference> references;
  final List<Alliance> alliances;
  final List<Consulate> consulates;

  /// Constructor completo con datos anidados
  factory Office.fromFullJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return Office(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      city: data['city'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      poBoxForUscis: data['po_box_for_uscis'] ?? '',
      mmFax: data['mm_fax'],
      cityEmail: data['city_email'],
      officeDirector: data['office_director'],
      officeDirectorEmail: data['office_director_email'],
      urlGoogleMaps: data['url_google_maps'],
      lat: double.tryParse(data['lat']?.toString() ?? ''),
      lon: double.tryParse(data['lon']?.toString() ?? ''),

      // `imageUrl` se asigna después con `copyWith`
      references:
          (json['references'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e))
              .toList() ??
          [],
      alliances:
          (json['alliances'] as List<dynamic>?)
              ?.map((e) => Alliance.fromJson(e))
              .toList() ??
          [],
      consulates:
          (json['consulates'] as List<dynamic>?)
              ?.map((e) => Consulate.fromJson(e))
              .toList() ??
          [],
    );
  }

  Office copyWith({
    int? id,
    String? name,
    String? city,
    String? address,
    String? phone,
    String? poBoxForUscis,
    String? mmFax,
    String? cityEmail,
    String? officeDirector,
    String? officeDirectorEmail,
    String? urlGoogleMaps,
    String? imageUrl,
    List<Reference>? references,
    List<Alliance>? alliances,
    List<Consulate>? consulates,
    double? lat,
    double? lon,
  }) {
    return Office(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      poBoxForUscis: poBoxForUscis ?? this.poBoxForUscis,
      mmFax: mmFax ?? this.mmFax,
      cityEmail: cityEmail ?? this.cityEmail,
      officeDirector: officeDirector ?? this.officeDirector,
      officeDirectorEmail: officeDirectorEmail ?? this.officeDirectorEmail,
      urlGoogleMaps: urlGoogleMaps ?? this.urlGoogleMaps,
      imageUrl: imageUrl ?? this.imageUrl,
      references: references ?? this.references,
      alliances: alliances ?? this.alliances,
      consulates: consulates ?? this.consulates,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'phone': phone,
      'po_box_for_uscis': poBoxForUscis,
      'mm_fax': mmFax,
      'city_email': cityEmail,
      'office_director': officeDirector,
      'office_director_email': officeDirectorEmail,
      'url_google_maps': urlGoogleMaps,
      'image_url': imageUrl,
      'references': references.map((e) => e.toJson()).toList(),
      'alliances': alliances.map((e) => e.toJson()).toList(),
      'consulates': consulates.map((e) => e.toJson()).toList(),
      'lat': lat,
      'lon': lon,
    };
  }
}
