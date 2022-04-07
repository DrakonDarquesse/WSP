import 'package:app/models/load_session.dart';
import 'package:app/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSession extends StateNotifier<Member?> {
  UserSession({required this.loadSession}) : super(null);

  final LoadSession loadSession;
  late final String? id;
  late final String? role;

  void getId() async {
    try {
      await loadSession.loadId();
    } finally {
      id = loadSession.signedInMemberId;
      getMember();
    }
  }

  void getMember() async {
    try {
      state = null;
      await loadSession.loadMember();
    } finally {
      state = loadSession.member;
      role = loadSession.role;
    }
  }
}
