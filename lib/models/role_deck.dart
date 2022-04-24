import 'package:app/models/role.dart';

class RoleDeck {
  Set<Role> roles;
  String title;
  String? id;

  RoleDeck({
    required this.title,
    required this.roles,
    this.id,
  });

  String getRoles() {
    return roles.fold(
        '', (previousValue, element) => previousValue + ' ' + element.name);
  }

  factory RoleDeck.fromJson(Map<String, dynamic> json) {
    Set<dynamic> roles =
        json['roles'].map((data) => Role.fromJson(data)).toSet();
    return RoleDeck(
      id: json['id'],
      title: json['title'],
      roles: roles.cast<Role>(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "roles": roles.map((r) => r.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) {
    return other is RoleDeck && title == other.title;
  }

  @override
  int get hashCode => title.hashCode;
}
