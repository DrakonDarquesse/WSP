import 'package:app/models/load_list.dart';
import 'package:app/models/role_deck.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleDeckList extends StateNotifier<List<RoleDeck>> {
  RoleDeckList({required this.loadList}) : super([]);

  final LoadList loadList;

  void load() async {
    try {
      state = [];
      await loadList.loadRoleDeck();
    } finally {
      state = loadList.roleDecks;
    }
  }
}
