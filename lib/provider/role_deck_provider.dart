import 'package:app/models/role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedRolesProvider = StateProvider<Set<Role>>((ref) {
  return {};
});

final titleProvider = StateProvider<String>((ref) {
  return '';
});
