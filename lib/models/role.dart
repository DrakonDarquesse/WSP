import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Role {
  String name;
  String task;
  bool isEnabled;
  Color color;

  Role(
      {required this.name,
      required this.task,
      this.color = Colors.blueGrey,
      this.isEnabled = true});
}
