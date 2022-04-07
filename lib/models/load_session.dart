import 'package:app/models/member.dart';
import 'package:app/network/member.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadSession {
  String? signedInMemberId;
  Member? member;
  String? role;

  // this will succeed or throw an error
  Future<void> loadId() async {
    final prefs = await SharedPreferences.getInstance();
    signedInMemberId = prefs.getString('token');
  }

  Future<void> loadMember() async {
    dynamic data = await getOneMember(signedInMemberId!);
    member = Member.fromJson(data);
    role = data['role'];
  }
}
