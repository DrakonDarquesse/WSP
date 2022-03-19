import 'package:app/models/load_list.dart';
import 'package:app/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberList extends StateNotifier<List<Member>> {
  MemberList({required this.loadList}) : super([]);

  final LoadList loadList;

  void load() async {
    try {
      state = [];
      await loadList.loadMember();
    } finally {
      state = loadList.members;
    }
  }
}
