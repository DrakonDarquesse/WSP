import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/role.dart';
import 'package:http/http.dart';

Future<List<Role>> fetchRole() async {
  const String api_url = 'http://localhost:3000/role';
  Response response = await http.get(
    Uri.parse(api_url),
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> something =
        jsonDecode(response.body).map((data) => Role.fromJson(data)).toList();
    return something.cast<Role>();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load role');
  }
}

Future<void> addRole(Role role) async {
  const String api_url = 'http://localhost:3000/addRole';

  Map<String, dynamic> body = role.toJson();

  Response response = await http.post(
    Uri.parse(api_url),
    body: jsonEncode(body),
    headers: {
      "content-type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load role');
  }
}
