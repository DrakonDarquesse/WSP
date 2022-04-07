import 'package:app/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberNotifier extends StateNotifier<Member> {
  MemberNotifier()
      : super(Member(email: '', name: '', roles: [], blockedDates: []));

  void reset() {
    state = Member(email: '', name: '', roles: [], blockedDates: []);
  }

  void assign(Member member) {
    state = member;
  }
}
