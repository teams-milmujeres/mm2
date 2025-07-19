class DocumentHistory {
  final String state;
  final String? stateNote;

  DocumentHistory({required this.state, this.stateNote});

  factory DocumentHistory.fromJson(Map<String, dynamic> json) {
    return DocumentHistory(
      state: json['state'] ?? '',
      stateNote: json['state_note_es'],
    );
  }

  Map<String, dynamic> toJson() => {'state': state, 'state_note_es': stateNote};
}
