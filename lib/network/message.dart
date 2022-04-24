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

void notification() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
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
