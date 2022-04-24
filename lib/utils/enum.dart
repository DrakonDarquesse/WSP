import 'package:flutter/material.dart';

enum Mode { edit, read, add }
enum Model { role, member, roster, roleMember, blockedDate }
enum Nav { roster, schedule, members, roles, profile, roleDeck }
enum Status {
  accepted,
  pending,
  rejected,
  unattended,
  changeTarget,
  changeSource,
  change,
}

extension NavExtension on Nav {
  String get displayText {
    switch (this) {
      case Nav.schedule:
        return "Schedule";
      case Nav.roster:
        return "Roster";
      case Nav.roles:
        return "Roles";
      case Nav.members:
        return "Member";
      case Nav.profile:
        return "Profile";
      case Nav.roleDeck:
        return "Role Set";
    }
  }

  Icon get displayIcon {
    switch (this) {
      case Nav.schedule:
        return const Icon(Icons.schedule);
      case Nav.roster:
        return const Icon(Icons.event);
      case Nav.roles:
        return const Icon(Icons.tag);
      case Nav.members:
        return const Icon(Icons.group);
      case Nav.profile:
        return const Icon(Icons.account_circle_outlined);
      case Nav.roleDeck:
        return const Icon(Icons.view_column_outlined);
    }
  }
}
