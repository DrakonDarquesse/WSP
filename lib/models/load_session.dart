import 'package:app/models/member.dart';
import 'package:app/network/auth.dart';
import 'package:app/network/member.dart';

class LoadSession {
  String? signedInMemberId;
  Member? member;
  String? role;
  dynamic data;

  void quickIdLoad(String id) {
    signedInMemberId = id;
    loadMember();
  }

  Future<void> loadMember() async {
    await loadMemberIfSignedIn();
    print('hmm');
    if (signedInMemberId != null) {
      print('hmm2');
      try {
        data = await getOneMember(signedInMemberId!);
      } finally {
        member = Member.fromJson(data);
        role = data['role'];
      }
    }
  }

  Future<void> loadMemberIfSignedIn() async {
    try {
      data = await checkAuth();
    } finally {
      if (data['err'] == null) {
        member = Member.fromJson(data);
        role = data['role'];
      }
    }
  }

  Future<void> clearSession() async {
    member = null;
    role = null;
    signedInMemberId = null;
  }
}
