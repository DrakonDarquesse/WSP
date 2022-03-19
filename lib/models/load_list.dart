import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/network/member.dart';
import 'package:app/network/role.dart';

class LoadList {
  late List<Role> roles;
  late List<Member> members;
  // this will succeed or throw an error
  Future<void> loadRole() async {
    roles = await fetchRole();
  }

  Future<void> loadMember() async {
    members = await fetchMember();
  }
}
