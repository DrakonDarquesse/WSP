import 'package:app/models/role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleNotifier extends StateNotifier<Role> {
  RoleNotifier() : super(Role(name: '', task: ''));

  void reset() {
    state = Role(name: '', task: '');
  }

  void assign(Role role) {
    state = role;
  }
}
