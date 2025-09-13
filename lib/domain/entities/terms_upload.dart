class TermsAndConditionsUpload {
  final int version;
  final String termsEn;
  final String termsEs;
  final String summaryEn;
  final String summaryEs;
  final DateTime? publishedAt;

  TermsAndConditionsUpload({
    required this.version,
    required this.termsEn,
    required this.termsEs,
    required this.summaryEn,
    required this.summaryEs,
    required this.publishedAt,
  });

  factory TermsAndConditionsUpload.fromJson(Map<String, dynamic> json) {
    DateTime? publishedDate;
    final publishedRaw = json['published_at'];
    if (publishedRaw != null && publishedRaw is String) {
      try {
        publishedDate = DateTime.parse(publishedRaw);
      } catch (_) {
        publishedDate = null;
      }
    }

    return TermsAndConditionsUpload(
      version:
          (json['version'] is int)
              ? json['version']
              : int.tryParse(json['version'].toString()) ?? 0,
      termsEn: json['terms_en']?.toString() ?? '',
      termsEs: json['terms_es']?.toString() ?? '',
      summaryEn: json['summary_en']?.toString() ?? '',
      summaryEs: json['summary_es']?.toString() ?? '',
      publishedAt: publishedDate,
    );
  }
}
