import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Role {
  String name;
  String task;
  bool isEnabled;
  Color color;

  String getIsEnabled() {
    if (isEnabled) {
      return 'Enabled';
    }
    return 'Disabled';
  }

  Role(
      {required this.name,
      required this.task,
      this.color = Colors.blueGrey,
      this.isEnabled = true});
}
