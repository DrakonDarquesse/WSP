import 'package:app/models/member.dart';
import 'package:app/models/member_list.dart';
import 'package:app/models/role.dart';
import 'package:app/models/role_list.dart';
import 'package:app/models/load_list.dart';
import 'package:app/utils/enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/nav_index.dart';

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

final loadListProvider = Provider<LoadList>((ref) => LoadList());

final modeProvider = StateProvider<Mode>((ref) => Mode.read);

final modelProvider = StateProvider<Model>((ref) => Model.role);

final navIndexProvider =
    StateNotifierProvider<NavIndex, int>((ref) => NavIndex());
