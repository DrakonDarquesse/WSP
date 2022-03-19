import 'package:app/models/load_list.dart';
import 'package:app/models/role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleList extends StateNotifier<List<Role>> {
  RoleList({required this.loadList}) : super([]);

  final LoadList loadList;

  void load() async {
    try {
      state = [];
      await loadList.loadRole();
    } finally {
      state = loadList.roles;
    }
  }
}
