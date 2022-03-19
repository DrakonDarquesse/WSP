import 'package:flutter/material.dart';

class Role {
  String? id;
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

  Role({
    this.id,
    required this.name,
    required this.task,
    this.color = Colors.blueGrey,
    this.isEnabled = true,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      task: json['task'],
      color: Color(json['color']),
      isEnabled: json['isEnabled'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "task": task,
        "color": color.value,
        "isEnabled": isEnabled,
      };
}
