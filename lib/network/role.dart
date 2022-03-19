import 'dart:convert';
import 'package:http/http.dart';
import 'package:app/models/role.dart';

Future<List<Role>> fetchRole() async {
  const String api_url = 'http://localhost:3000/roles';
  Response response = await get(
    Uri.parse(api_url),
  );
  if (response.statusCode == 200) {
    List<dynamic> roles =
        jsonDecode(response.body).map((data) => Role.fromJson(data)).toList();
    return roles.cast<Role>();
  } else {
    throw Exception('Failed to load role');
  }
}

Future<void> addRole(Role role) async {
  const String api_url = 'http://localhost:3000/addRole';

  Map<String, dynamic> body = role.toJson();

  Response response = await post(
    Uri.parse(api_url),
    body: jsonEncode(body),
    headers: {
      "content-type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    // something
  } else {
    throw Exception('Failed to add role');
  }
}

Future<void> editRole(Role role) async {
  const String api_url = 'http://localhost:3000/editRole';

  Map<String, dynamic> body = role.toJson();

  Response response = await post(
    Uri.parse(api_url),
    body: jsonEncode(body),
    headers: {
      "content-type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    // something
  } else {
    throw Exception('Failed to edit role');
  }
}

Future<void> deleteRole(Role role) async {
  const String api_url = 'http://localhost:3000/deleteRole';

  Map<String, dynamic> body = role.toJson();

  Response response = await post(
    Uri.parse(api_url),
    body: jsonEncode(body),
    headers: {
      "content-type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    // something
  } else {
    throw Exception('Failed to delete role');
  }
}
