import 'package:app/models/role.dart';

class Member {
  String email;
  String password;
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
    required this.password,
    required this.name,
    this.isActive = true,
    this.roles = const [],
    this.blockedDates = const [],
  });
}
