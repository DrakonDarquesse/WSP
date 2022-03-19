import 'dart:convert';
import 'package:http/http.dart';
import 'package:app/models/member.dart';

Future<List<Member>> fetchMember() async {
  const String api_url = 'http://localhost:3000/members';
  Response response = await get(
    Uri.parse(api_url),
  );
  if (response.statusCode == 200) {
    List<dynamic> members =
        jsonDecode(response.body).map((data) => Member.fromJson(data)).toList();
    return members.cast<Member>();
  } else {
    throw Exception('Failed to load member');
  }
}

Future<void> editMember(Member role) async {
  const String api_url = 'http://localhost:3000/editMember';

  Map<String, dynamic> body = role.toJson();
  print(jsonEncode(body));

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

Future<void> deleteMember(Member member) async {
  const String api_url = 'http://localhost:3000/deleteRole';

  Map<String, dynamic> body = member.toJson();
  print(jsonEncode(body));

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
