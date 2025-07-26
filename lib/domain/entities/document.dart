import 'document_type.dart';
import 'document_history.dart';

class Document {
  final int id;
  final String noteEN;
  final String noteES;
  final bool uploaded;
  final bool checked;
  final DateTime createdAt;
  final String? googleDriveUrl;
  final DocumentType documentType;
  final List<DocumentHistory> histories;

  Document({
    required this.id,
    required this.noteEN,
    required this.noteES,
    required this.uploaded,
    required this.checked,
    required this.createdAt,
    required this.documentType,
    required this.histories,
    this.googleDriveUrl,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      noteES: json['note_es'] ?? '',
      noteEN: json['note_en'] ?? '',
      uploaded: json['uploaded'] ?? false,
      checked: json['checked'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      googleDriveUrl: json['google_drive_url'],
      documentType: DocumentType.fromJson(json['document_type']),
      histories:
          (json['histories'] as List<dynamic>?)
              ?.map((e) => DocumentHistory.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'note_es': noteES,
    'note_en': noteEN,
    'uploaded': uploaded,
    'checked': checked,
    'created_at': createdAt.toIso8601String(),
    'google_drive_url': googleDriveUrl,
    'document_type': documentType.toJson(),
    'histories': histories.map((e) => e.toJson()).toList(),
  };
}
