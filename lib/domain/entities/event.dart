class Event {
  final int id;
  final String titleEs;
  final String titleEn;
  final String bodyEs;
  final String bodyEn;
  final String summaryEs;
  final String summaryEn;
  final String city;
  final DateTime? eventDate;
  final DateTime? createdDate;
  final String? eventTypeId;
  final bool isEvent;
  final bool important;
  final String? sourceLink;

  Event({
    required this.id,
    required this.titleEn,
    required this.titleEs,
    required this.bodyEn,
    required this.bodyEs,
    required this.summaryEn,
    required this.summaryEs,
    required this.city,
    this.eventDate,
    this.createdDate,
    this.eventTypeId,
    required this.isEvent,
    required this.important,
    this.sourceLink,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      titleEn: json['title_en'],
      titleEs: json['title_es'],
      bodyEn: json['body_en'],
      bodyEs: json['body_es'],
      summaryEn: json['summary_en'],
      summaryEs: json['summary_es'],
      city: json['city'],
      eventDate:
          json['event_date'] != null
              ? DateTime.parse(json['event_date'])
              : null,
      createdDate:
          json['created_date'] != null
              ? DateTime.parse(json['created_date'])
              : null,
      eventTypeId: json['event_type_id'],
      isEvent: json['is_event'],
      important: json['important'],
      sourceLink: json['source_link'],
    );
  }

  Event copyWith({
    int? id,
    String? titleEn,
    String? titleEs,
    String? bodyEn,
    String? bodyEs,
    String? summaryEn,
    String? summaryEs,
    String? city,
    DateTime? eventDate,
    DateTime? createdDate,
    String? eventTypeId,
    bool? isEvent,
    bool? important,
    String? sourceLink,
  }) {
    return Event(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleEs: titleEs ?? this.titleEs,
      bodyEn: bodyEn ?? this.bodyEn,
      bodyEs: bodyEs ?? this.bodyEs,
      summaryEn: summaryEn ?? this.summaryEn,
      summaryEs: summaryEs ?? this.summaryEs,
      city: city ?? this.city,
      eventDate: eventDate ?? this.eventDate,
      createdDate: createdDate ?? this.createdDate,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      isEvent: isEvent ?? this.isEvent,
      important: important ?? this.important,
      sourceLink: sourceLink ?? this.sourceLink,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title_en": titleEn,
    "title_es": titleEs,
    "body_en": bodyEn,
    "body_es": bodyEs,
    "summary_en": summaryEn,
    "summary_es": summaryEs,
    "city": city,
    "event_date": eventDate?.toIso8601String(),
    "created_date": createdDate?.toIso8601String(),
    "event_type_id": eventTypeId,
    "is_event": isEvent,
    "important": important,
    "source_link": sourceLink,
  };

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      titleEn: map['title_en'],
      titleEs: map['title_es'],
      bodyEn: map['body_en'],
      bodyEs: map['body_es'],
      summaryEn: map['summary_en'],
      summaryEs: map['summary_es'],
      city: map['city'],
      eventDate:
          map['event_date'] != null ? DateTime.parse(map['event_date']) : null,
      createdDate:
          map['created_date'] != null
              ? DateTime.parse(map['created_date'])
              : null,
      eventTypeId: map['event_type_id'],
      isEvent: map['is_event'],
      important: map['important'],
      sourceLink: map['source_link'],
    );
  }
}
