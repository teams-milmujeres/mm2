class Staff {
  final List<StaffMember> executiveTeam;
  final List<StaffMember> legalTeam;

  Staff({required this.executiveTeam, required this.legalTeam});

  Staff copyWith({
    List<StaffMember>? executiveTeam,
    List<StaffMember>? legalTeam,
  }) => Staff(
    executiveTeam: executiveTeam ?? this.executiveTeam,
    legalTeam: legalTeam ?? this.legalTeam,
  );
}

class StaffMember {
  final String name;
  final String role;
  final int staffOrder;
  final int userId;
  final DateTime upd;
  final int id;

  StaffMember({
    required this.name,
    required this.role,
    required this.staffOrder,
    required this.userId,
    required this.upd,
    required this.id,
  });

  StaffMember copyWith({
    String? name,
    String? role,
    int? staffOrder,
    int? userId,
    DateTime? upd,
    int? id,
  }) => StaffMember(
    name: name ?? this.name,
    role: role ?? this.role,
    staffOrder: staffOrder ?? this.staffOrder,
    userId: userId ?? this.userId,
    upd: upd ?? this.upd,
    id: id ?? this.id,
  );

  factory StaffMember.fromJson(Map<String, dynamic> json) => StaffMember(
    name: json["name"] ?? '',
    role: json["role"] ?? '',
    staffOrder: json["staff_order"] ?? 0,
    userId: json["user_id"] ?? 0,
    upd: DateTime.tryParse(json["upd"] ?? '') ?? DateTime.now(),
    id: json["id"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "staff_order": staffOrder,
    "user_id": userId,
    "upd": upd.toIso8601String(),
    "id": id,
  };
}
