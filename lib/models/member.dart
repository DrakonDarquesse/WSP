import 'package:app/models/role.dart';

class Member {
  String email;
  String password;
  String name;
  bool isActive;
  List<Role> roles;

  Member({
    required this.email,
    required this.password,
    required this.name,
    this.isActive = true,
    this.roles = const [],
  });
}
