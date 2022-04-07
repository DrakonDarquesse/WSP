import 'package:app/models/duty_roster.dart';
import 'package:app/models/load_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RosterList extends StateNotifier<List<DutyRoster>> {
  RosterList({required this.loadList}) : super([]);

  final LoadList loadList;

  void load() async {
    try {
      state = [];
      await loadList.loadRoster();
    } finally {
      state = loadList.rosters;
    }
  }
}
