import 'package:app/models/blocked_date.dart';
import 'package:app/models/role.dart';

class Member {
  String? id;
  String email;
  String name;
  bool isActive;
  List<Role> roles;
  List<BlockedDate> blockedDates;

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

  Member.empty({
    this.blockedDates = const [],
    this.name = '',
    this.email = '',
    this.isActive = true,
    this.roles = const [],
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    List<dynamic> roles = json['roles'] != null
        ? json['roles'].map((data) => Role.fromJson(data)).toList()
        : [];
    List<dynamic> blockedDates = json['blockedDates'] != null
        ? json['blockedDates']
            .map((data) => BlockedDate.fromJson(data))
            .toList()
        : [];

    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['isEnabled'],
      roles: roles.cast<Role>(),
      blockedDates: blockedDates.cast<BlockedDate>(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "isEnabled": isActive,
        "roles": roles.map((r) => r.toJson()).toList(),
        "blockedDates": blockedDates.map((r) => r.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) {
    return other is Member &&
        name.toLowerCase() == other.name.toLowerCase() &&
        email == other.email;
  }
}
