import 'package:app/models/role.dart';

class Member {
  String? id;
  String email;
  String name;
  bool isActive;
  List<Role> roles;
  List<DateTime> blockedDates;

  String getIsActive() {
    if (isActive) {
      return 'Active';
    }
    return 'Inactive';
  }

  Member({
    required this.email,
    required this.name,
    this.isActive = true,
    required this.roles,
    required this.blockedDates,
    this.id,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    List<dynamic> roles =
        json['roles'].map((data) => Role.fromJson(data)).toList();
    List<dynamic> blockedDates =
        json['blockedDates'].map((data) => Role.fromJson(data)).toList();

    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['isEnabled'],
      roles: roles.cast<Role>(),
      blockedDates: blockedDates.cast<DateTime>(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "isEnabled": isActive,
        "roles": roles.map((r) => r.toJson()).toList(),
      };
}
