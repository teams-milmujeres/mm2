class DocumentType {
  final int id;
  final String nameEn;
  final String nameEs;

  DocumentType({required this.id, required this.nameEn, required this.nameEs});

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['id'],
      nameEn: json['name_en'] ?? '',
      nameEs: json['name_es'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name_en': nameEn,
    'name_es': nameEs,
  };
}
