import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/utils/enum.dart';

List<Map<String, dynamic>> getMemberRoster(
    Member? member, List<DutyRoster> rosters) {
  return rosters.fold<List<Map<String, dynamic>>>([], (a, b) {
    List<Map<String, dynamic>> rm = b.roleMembers
        .where((e) => e.member == member)
        .map<Map<String, dynamic>>(
            (e) => {'id': b.id, 'date': b.date, 'roleMember': e})
        .toList();
    if (rm.isNotEmpty) {
      a.addAll(rm);
    }
    return a;
  });
}

Member? getMember(String id, List<Member> members) {
  if (members.isEmpty) return null;
  return members.singleWhere((m) => m.id == id);
}

List<Map<String, dynamic>> getPending(List<Map<String, dynamic>> rosters) {
  return rosters.where((e) {
    return e['roleMember'].status == Status.pending;
  }).toList();
}

List<Map<String, dynamic>> getAccepted(List<Map<String, dynamic>> rosters) {
  return rosters.where((e) {
    return e['roleMember'].status == Status.accepted;
  }).toList();
}
