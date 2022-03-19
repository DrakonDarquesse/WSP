import 'package:flutter/material.dart';

enum Mode { edit, read, add }
enum Model { role, member }
enum Nav { roster, schedule, members, roles }

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
        return const Icon(Icons.person);
    }
  }
}
