import 'dart:convert';
import 'package:app/models/role_deck.dart';
import 'package:http/http.dart';

Future<List<RoleDeck>> fetchRoleDeck() async {
  const String api_url = 'http://localhost:3000/roleDecks';
  Response response = await get(
    Uri.parse(api_url),
  );
  if (response.statusCode == 200) {
    List<dynamic> roleDecks = jsonDecode(response.body)
        .map((data) => RoleDeck.fromJson(data))
        .toList();
    return roleDecks.cast<RoleDeck>();
  } else {
    throw Exception('Failed to load member');
  }
}

Future<void> addRoleDeck(RoleDeck roleDeck) async {
  const String api_url = 'http://localhost:3000/addRoleDeck';

  Map<String, dynamic> body = roleDeck.toJson();

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

Future<void> editRoleDeck(RoleDeck roleDeck) async {
  const String api_url = 'http://localhost:3000/editRoleDeck';

  Map<String, dynamic> body = roleDeck.toJson();

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

Future<void> deleteRoleDeck(RoleDeck roleDeck) async {
  const String api_url = 'http://localhost:3000/deleteRoleDeck';

  Map<String, dynamic> body = roleDeck.toJson();
  // print(jsonEncode(body));

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
