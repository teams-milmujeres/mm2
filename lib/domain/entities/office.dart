class Office {
  Office({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
    required this.poBoxForUscis,
    required this.mmFax,
    required this.cityEmail,
    required this.officeDirector,
    required this.officeDirectorEmail,
    required this.urlGoogleMaps,
    this.imageUrl,
  });

  int id;
  String name;
  String city;
  String address;
  String phone;
  String poBoxForUscis;
  String? mmFax;
  String? cityEmail;
  String? officeDirector;
  String? officeDirectorEmail;
  String? urlGoogleMaps;
  String? imageUrl;

  factory Office.fromJson(Map<String, dynamic> json) => Office(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    city: json['city'] ?? '',
    address: json['address'] ?? '',
    phone: json['phone'] ?? '',
    poBoxForUscis: json['po_box_for_uscis'] ?? '',
    mmFax: json['mm_fax'] ?? '',
    cityEmail: json['city_email'] ?? '',
    officeDirector: json['office_director'] ?? '',
    officeDirectorEmail: json['office_director_email'] ?? '',
    urlGoogleMaps: json['url_google_maps'] ?? '',
    imageUrl: json['image_url'] ?? '',
  );

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
  }) => Office(
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
  );

  Map<String, dynamic> toJson() => {
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
  };
}
