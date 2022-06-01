import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_member.dart';
import 'package:app/utils/enum.dart';
import 'package:intl/intl.dart';

List<Map<String, dynamic>> messageFactory(DutyRoster roster) {
  String date = DateFormat('yMd').format(roster.date);
  return roster.roleMembers
      .map<Map<String, dynamic>>((e) => makeMessage(e, date))
      .toList();
}

Map<String, dynamic> makeMessage(RoleMember roleMember, String date) {
  Member member = roleMember.member;
  Role role = roleMember.role;
  Status status = roleMember.status;
  if (status == Status.pending || status == Status.accepted) {
    return {
      'message': {
        'title': "Duty Reminder",
        'body': "You have duty on $date as ${role.name}"
      },
      'receiver': member.id
    };
  }

  return {};
}
