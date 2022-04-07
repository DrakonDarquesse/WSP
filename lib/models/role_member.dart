import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/utils/enum.dart';

class RoleMember {
  Role role;
  Member member;
  Status status;

  RoleMember({
    required this.role,
    required this.member,
    this.status = Status.pending,
  });

  factory RoleMember.fromJson(Map<String, dynamic> json) {
    return RoleMember(
      role: Role.fromJson(json['role']),
      member: Member.fromJson(json['member']),
      status: Status.values.firstWhere((e) => e.toString() == json['status']),
    );
  }

  Map<String, dynamic> toJson() => {
        "role": role,
        "member": {
          "name": member.name,
          "email": member.email,
          "isEnabled": member.isActive,
        },
        "status": status.toString(),
      };

  @override
  bool operator ==(Object other) {
    return other is RoleMember && role == other.role && member == other.member;
  }
}
