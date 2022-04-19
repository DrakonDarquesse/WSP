import 'package:app/screens/admin_role_deck_list.dart';
import 'package:app/screens/admin_roster_list.dart';
import 'package:app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'screens/all.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/memberSchedule': (context) => const MemberSchedule(
        title: 'Home',
      ),
  '/role': (context) => const AdminRoleList(),
  '/member': (context) => const AdminMemberList(),
  '/login': (context) => const Login(),
  '/register': (context) => const Register(),
  '/roster': (context) => const AdminRosterList(),
  '/profile': (context) => const Profile(),
  '/roleDeck': (context) => const AdminRoleDeckList(),
};

Map<String, int> navRoutes = {
  '/memberSchedule': 0,
  '/profile': 1,
  '/role': 2,
  '/member': 3,
  '/roster': 4,
  '/roleDeck': 2,
};
