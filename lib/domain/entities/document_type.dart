class DocumentType {
  final int id;
  final String nameEn;

  DocumentType({required this.id, required this.nameEn});

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(id: json['id'], nameEn: json['name_en'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name_en': nameEn};
}
