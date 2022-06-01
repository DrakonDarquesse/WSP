import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> saveTokenToDatabase(String token) async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/sendToken';
  // const String api_url = 'http://localhost:3000/editMember';

  Map<String, dynamic> body = {'token': token};

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
    throw Exception('Failed to token');
  }
}

Future<void> sendMessage(String id) async {
  const String api_url = 'https://afternoon-shore-55342.herokuapp.com/sendMsg';
  // const String api_url = 'http://localhost:3000/editMember';

  Map<String, dynamic> body = {'receiver': id};

  print(body);

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
    throw Exception('Failed to id');
  }
}

Future<void> sendMessages(List<Map<String, dynamic>> messages) async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/sendMessages';
  // const String api_url = 'http://localhost:3000/editMember';

  Map<String, dynamic> body = {'messages': messages};

  print(body);

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
    throw Exception('Failed to something');
  }
}

void token() async {
  String? token = await messaging.getToken(
    vapidKey:
        "BBnVMYuBSV8B5KEx1AGESp_Sp6rAu9FpPKls66pcgCG85tVPEm8F-Ob9vt66ooosMMc4kFPK0H8eDgK7kerDmtw",
  );

  print(token);

  await saveTokenToDatabase(token!);

  // Any time the token refreshes, store this in the database too.
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
}
