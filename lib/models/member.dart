import 'package:app/models/role.dart';

class Member {
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
    this.roles = const [],
    this.blockedDates = const [],
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      email: json['email'],
      isActive: json['isActive'],
      // roles: json['roles'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "isActive": isActive,
        // "isEnabled": isEnabled,
      };
}
