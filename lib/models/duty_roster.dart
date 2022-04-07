import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_member.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

Function eq = const DeepCollectionEquality.unordered().equals;

class DutyRoster {
  String? id;
  DateTime date;
  String title;
  List<RoleMember> roleMembers;

  DutyRoster({
    required this.date,
    required this.title,
    required this.roleMembers,
    this.id,
  });

  List<Member> getMembers() {
    return roleMembers.map<Member>((e) => e.member).toList();
  }

  Set<Role> getRoles() {
    return roleMembers.map<Role>((e) => e.role).toSet();
  }

  factory DutyRoster.fromJson(Map<String, dynamic> json) {
    List<dynamic> roleMember =
        json['roleMember'].map((data) => RoleMember.fromJson(data)).toList();
    return DutyRoster(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      roleMembers: roleMember.cast<RoleMember>(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date.toIso8601String(),
        "title": title,
        "roleMember": roleMembers.map((r) => r.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) {
    return other is DutyRoster && setEquals(getRoles(), other.getRoles());
  }
}
