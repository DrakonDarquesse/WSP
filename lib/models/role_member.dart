import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/utils/enum.dart';

class RoleMember {
  Role role;
  Member member;
  Status status;
  String? link;
  RoleMember? src;

  RoleMember({
    required this.role,
    required this.member,
    this.status = Status.pending,
    this.link,
    this.src,
  });

  factory RoleMember.shallow(RoleMember ori) {
    return RoleMember(
        role: ori.role, member: ori.member, status: Status.change);
  }

  factory RoleMember.fromJson(Map<String, dynamic> json) {
    return RoleMember(
      role: Role.fromJson(json['role']),
      member: Member.fromJson(json['member']),
      status: Status.values.firstWhere((e) => e.toString() == json['status']),
      link: json['link'],
      src: json['src'] != null ? RoleMember.fromJson(json['src']) : null,
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
        "link": link,
        "src": src?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    return other is RoleMember && role == other.role && member == other.member;
  }
}
