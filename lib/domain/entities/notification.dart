import 'package:intl/intl.dart';

class Notification {
  final int id;
  final int clientId;
  final String title;
  final String body;
  final String date;
  final bool read;
  final String type;
  final bool sent;

  Notification({
    required this.id,
    required this.clientId,
    required this.title,
    required this.body,
    required this.date,
    required this.read,
    required this.type,
    required this.sent,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      clientId: json['client_id'],
      title: json['content']['title'],
      body: json['content']['body'],
      date: DateFormat(
        'yyyy-MM-dd – kk:mm',
      ).format(DateTime.parse(json['created_at'])),

      read: false,
      type: json['type'],
      sent: json['sent'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "title": title,
    "body": body,
    "date": date,
    "read": read,
    "type": type,
    "sent": sent,
  };
}
