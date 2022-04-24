import 'dart:convert';
import 'package:http/http.dart';
import 'package:app/models/duty_roster.dart';

Future<List<DutyRoster>> fetchRoster() async {
  const String api_url = 'https://afternoon-shore-55342.herokuapp.com/rosters';
  // const String api_url = 'http://localhost:3000/rosters';
  Response response = await get(
    Uri.parse(api_url),
  );

  if (response.statusCode == 200) {
    List<dynamic> roster = jsonDecode(response.body)
        .map((data) => DutyRoster.fromJson(data))
        .toList();
    return roster.cast<DutyRoster>();
  } else {
    throw Exception('Failed to load member');
  }
}

Future<void> addRoster(DutyRoster roster) async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/addRoster';
  // const String api_url = 'http://localhost:3000/addRoster';

  Map<String, dynamic> body = roster.toJson();

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

Future<void> editRoster(DutyRoster roster) async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/editRoster';
  // const String api_url = 'http://localhost:3000/editRoster';

  Map<String, dynamic> body = roster.toJson();

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

Future<void> deleteRoster(DutyRoster roster) async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/deleteRoster';
  // const String api_url = 'http://localhost:3000/deleteRoster';

  Map<String, dynamic> body = roster.toJson();

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
