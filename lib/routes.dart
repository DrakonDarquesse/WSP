import 'package:flutter/material.dart';
import 'screens/all.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => const Loading(),
  '/home': (context) => const HomePage(title: 'Home'),
  '/memberSchedule': (context) => const MemberSchedule(
        title: 'Home',
      ),
  '/adminRoleList': (context) {
    return const AdminRoleList();
  },
  '/adminMemberList': (context) {
    return const AdminMemberList();
  },
  '/login': (context) => const Login(),
  '/register': (context) => const Register(),
};

List<String> navRoutes = [
  '/',
  '/',
  '/adminRoleList',
  '/adminMemberList',
];
