import 'package:app/models/duty_roster.dart';
import 'package:app/models/exchange.dart';
import 'package:app/models/exchange_list.dart';
import 'package:app/models/load_session.dart';
import 'package:app/models/member.dart';
import 'package:app/models/member_list.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_deck.dart';
import 'package:app/models/role_deck_list.dart';
import 'package:app/models/role_list.dart';
import 'package:app/models/load_list.dart';
import 'package:app/models/roster_list.dart';
import 'package:app/models/user_session.dart';
import 'package:app/utils/enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memberListProvider =
    StateNotifierProvider<MemberList, List<Member>>((ref) {
  final loadList = ref.watch(loadListProvider);
  MemberList memberList = MemberList(loadList: loadList);
  memberList.load();
  return memberList;
});

final roleListProvider = StateNotifierProvider<RoleList, List<Role>>((ref) {
  final loadList = ref.watch(loadListProvider);
  RoleList roleList = RoleList(loadList: loadList);
  roleList.load();
  return roleList;
});

final rosterListProvider =
    StateNotifierProvider<RosterList, List<DutyRoster>>((ref) {
  final loadList = ref.watch(loadListProvider);
  RosterList rosterList = RosterList(loadList: loadList);
  rosterList.load();
  return rosterList;
});

final roleDeckListProvider =
    StateNotifierProvider<RoleDeckList, List<RoleDeck>>((ref) {
  final loadList = ref.watch(loadListProvider);
  RoleDeckList roleDeckList = RoleDeckList(loadList: loadList);
  roleDeckList.load();
  return roleDeckList;
});

final exchangeListProvider =
    StateNotifierProvider<ExchangeList, List<Exchange>>((ref) {
  final loadList = ref.watch(loadListProvider);
  ExchangeList roleDeckList = ExchangeList(loadList: loadList);
  roleDeckList.load();
  return roleDeckList;
});

final loadListProvider = Provider<LoadList>((ref) => LoadList());

final loadSessionProvider = Provider<LoadSession>((ref) => LoadSession());

final modeProvider = StateProvider<Mode>((ref) => Mode.read);

final modelProvider = StateProvider<Model>((ref) => Model.role);

final sessionProvider = StateNotifierProvider<UserSession, Member?>((ref) {
  final loadSession = ref.watch(loadSessionProvider);
  UserSession userSession = UserSession(loadSession: loadSession);
  userSession.getMember();
  return userSession;
});
