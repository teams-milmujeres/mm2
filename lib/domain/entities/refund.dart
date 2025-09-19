import 'package:mm/domain/entities/user_teams.dart';

class Office {
  final int? id;
  final String? city;
  final String? name;
  final dynamic distance;

  Office({this.id, this.city, this.name, this.distance});

  factory Office.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Office(id: null, city: null, name: null, distance: null);
    }
    return Office(
      id: json['id'],
      city: json['city'],
      name: json['name'],
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'city': city,
    'name': name,
    'distance': distance,
  };
}

class Refund {
  Refund({
    required this.amount,
    this.applicationId,
    this.authorizedBy,
    this.authorizedById,
    this.caaseId,
    required this.checked,
    this.clientId,
    this.createdAt,
    this.dateSent,
    this.from,
    this.id,
    this.mmCheckNumber,
    required this.office,
    this.officeId,
    this.paymentMethod,
    this.refundDate,
    this.sentBy,
    this.taskId,
    this.updatedAt,
    this.user,
    this.userId,
  });

  double amount;
  int? applicationId;
  Userteams? authorizedBy;
  int? authorizedById;
  int? caaseId;
  bool checked;
  int? clientId;
  String? createdAt;
  String? dateSent;
  String? from;
  int? id;
  String? mmCheckNumber;
  Office office;
  int? officeId;
  String? paymentMethod;
  String? refundDate;
  String? sentBy;
  int? taskId;
  String? updatedAt;
  Userteams? user;
  int? userId;

  factory Refund.fromJson(Map<String, dynamic> json) => Refund(
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    applicationId: json['application_id'],
    authorizedBy:
        json['authorized_by'] != null
            ? Userteams.fromJson(json['authorized_by'])
            : null,
    authorizedById: json['authorized_by_id'],
    caaseId: json['caase_id'],
    checked: json['checked'] ?? false,
    clientId: json['client_id'],
    createdAt: json['created_at'],
    dateSent: json['date_sent'],
    from: json['from'],
    id: json['id'],
    mmCheckNumber: json['mm_check_number'],
    office: Office.fromJson(json['office']),
    officeId: json['office_id'],
    paymentMethod: json['type'],
    refundDate: json['disbursement_date'],
    sentBy: json['sent_by'],
    taskId: json['task_id'],
    updatedAt: json['updated_at'],
    user: json['user'] != null ? Userteams.fromJson(json['user']) : null,
    userId: json['user_id'],
  );
}
