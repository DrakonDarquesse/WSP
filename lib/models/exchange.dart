import 'package:app/models/role_member.dart';
import 'package:flutter/material.dart';

class Exchange {
  String? id;
  RoleMember target;
  RoleMember source;
  String targetid;
  String sourceid;
  String status;

  Exchange({
    this.id,
    required this.target,
    required this.source,
    required this.targetid,
    required this.sourceid,
    this.status = 'pending',
  });

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['id'],
      target: RoleMember.fromJson(json['target']),
      source: RoleMember.fromJson(json['source']),
      targetid: json['targetid'],
      sourceid: json['sourceid'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "target": target.toJson(),
        "source": source.toJson(),
        "targetid": targetid,
        "sourceid": sourceid,
        "status": status
      };

  // @override
  // bool operator ==(Object other) {
  //   return other is Role && name.toLowerCase() == other.name.toLowerCase();
  // }

  // @override
  // int get hashCode => name.hashCode;
}
