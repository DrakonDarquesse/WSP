import 'package:app/models/blocked_date.dart';
import 'package:app/models/duty_roster.dart';
import 'package:app/models/member.dart';
import 'package:app/models/member_notifier.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_member.dart';
import 'package:app/models/role_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rosterProvider = StateProvider<DutyRoster>((ref) {
  return DutyRoster(date: DateTime.now(), title: "", roleMembers: []);
});

final roleProvider = StateNotifierProvider<RoleNotifier, Role>((ref) {
  return RoleNotifier();
});

final memberProvider = StateNotifierProvider<MemberNotifier, Member>((ref) {
  return MemberNotifier();
});

final tempRoleMemberProvider = StateProvider<RoleMember?>((ref) {
  return null;
});

final blockedDateProvider = StateProvider<BlockedDate>((ref) {
  return BlockedDate(date: DateTime.now(), note: "");
});
