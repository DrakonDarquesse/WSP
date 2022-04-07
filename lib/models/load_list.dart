import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_deck.dart';
import 'package:app/network/member.dart';
import 'package:app/network/role.dart';
import 'package:app/network/role_deck.dart';
import 'package:app/network/roster.dart';

class LoadList {
  List<Role> roles = [];
  List<Member> members = [];
  List<DutyRoster> rosters = [];
  List<RoleDeck> roleDecks = [];

  // this will succeed or throw an error
  Future<void> loadRole() async {
    roles = await fetchRole();
  }

  Future<void> loadMember() async {
    members = await fetchMember();
  }

  Future<void> loadRoster() async {
    rosters = await fetchRoster();
  }

  Future<void> loadRoleDeck() async {
    roleDecks = await fetchRoleDeck();
  }
}
