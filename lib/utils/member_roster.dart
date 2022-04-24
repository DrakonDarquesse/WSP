import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role_member.dart';
import 'package:app/utils/enum.dart';

List<Map<String, dynamic>> getMemberRoster(
    Member? member, List<DutyRoster> rosters) {
  return rosters.fold<List<Map<String, dynamic>>>([], (a, b) {
    Iterable<RoleMember> rm = b.roleMembers.where((e) => e.member == member);
    List<Map<String, dynamic>> r = rm
        .map<Map<String, dynamic>>(
            (e) => {'id': b.id, 'date': b.date, 'roleMember': e})
        .toList();

    if (rm.isNotEmpty) {
      a.addAll(r);
    }
    return a;
  });
}

List<Map<String, dynamic>> getPending(List<Map<String, dynamic>> rosters) {
  return rosters.where((e) {
    return e['roleMember'].status == Status.pending ||
        e['roleMember'].status == Status.change;
  }).toList();
}

List<Map<String, dynamic>> getAccepted(List<Map<String, dynamic>> rosters) {
  return rosters.where((e) {
    return e['roleMember'].status == Status.accepted ||
        e['roleMember'].status == Status.changeSource ||
        e['roleMember'].status == Status.changeTarget;
  }).toList();
}
