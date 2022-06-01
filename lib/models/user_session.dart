import 'package:app/models/load_session.dart';
import 'package:app/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSession extends StateNotifier<Member?> {
  UserSession({required this.loadSession}) : super(null);

  final LoadSession loadSession;
  String? id;
  String? role;
  bool? signedIn;

  Future<void> getMember() async {
    try {
      signedIn = null;
      state = null;
      await loadSession.loadMember();
    } finally {
      state = loadSession.member;
      role = loadSession.role;
      signedIn = state != null;
    }
  }

  void clearSession() async {
    try {
      state = null;
      await loadSession.clearSession();
    } finally {
      state = loadSession.member;
      role = loadSession.role;
      signedIn = false;
    }
  }
}
