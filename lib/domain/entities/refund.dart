class Refund {
  Refund({
    required this.amount,
    required this.applicationId,
    required this.authorizedBy,
    required this.authorizedById,
    required this.caaseId,
    required this.checked,
    required this.clientId,
    required this.createdAt,
    required this.dateSent,
    required this.from,
    required this.id,
    required this.mmCheckNumber,
    required this.office,
    required this.officeId,
    required this.paymentMethod,
    required this.refundDate,
    required this.sentBy,
    required this.taskId,
    required this.updatedAt,
    required this.user,
    required this.userId,
  });

  String amount;
  String applicationId;
  var authorizedBy;
  String authorizedById;
  String caaseId;
  String checked;
  String clientId;
  String createdAt;
  String dateSent;
  String from;
  String id;
  String mmCheckNumber;
  var office;
  String officeId;
  String paymentMethod;
  String refundDate;
  String sentBy;
  String taskId;
  String updatedAt;
  var user;
  String userId;

  factory Refund.fromJson(Map<String, dynamic> json) => Refund(
    amount: json['amount'],
    applicationId: json['application_id'],
    authorizedBy: json['authorized_by'],
    authorizedById: json['authorized_by_id'],
    caaseId: json['caase_id'],
    checked: json['checked'],
    clientId: json['client_id'],
    createdAt: json['created_at'],
    dateSent: json['date_sent'],
    from: json['from'],
    id: json['id'],
    mmCheckNumber: json['mm_check_number'],
    office: json['office'],
    officeId: json['office_id'],
    paymentMethod: json['payment_method'],
    refundDate: json['refund_date'],
    sentBy: json['sent_by'],
    taskId: json['task_id'],
    updatedAt: json['updated_at'],
    user: json['user'],
    userId: json['user_id'],
  );

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'application_id': applicationId,
    'authorized_by': authorizedBy,
    'authorized_by_id': authorizedById,
    'caase_id': caaseId,
    'checked': checked,
    'client_id': clientId,
    'created_at': createdAt,
    'date_sent': dateSent,
    'from': from,
    'id': id,
    'mm_check_number': mmCheckNumber,
    'office': office,
    'office_id': officeId,
    'payment_method': paymentMethod,
    'refund_date': refundDate,
    'sent_by': sentBy,
    'task_id': taskId,
    'updated_at': updatedAt,
    'user': user,
    'user_id': userId,
  };
}
