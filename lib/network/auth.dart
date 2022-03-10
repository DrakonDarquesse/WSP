import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:app/models/member.dart';

Future<String?> login(String email, String password) async {
  const String api_url = 'http://localhost:3000/login';

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  return await http.post(
    Uri.parse(api_url),
    body: jsonEncode(body),
    headers: {
      "content-type": "application/json",
    },
  ).then((response) async {
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (response.body == 'auth/wrong-password') {
        return 'Wrong password.';
      }

      if (response.body == 'auth/user-not-found') {
        return 'User not found.';
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to login');
    }
  });
}

Future<String?> register(String email, String password) async {
  const String api_url = 'http://localhost:3000/register';

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  return await http.post(
    Uri.parse(api_url),
    body: jsonEncode(body),
    headers: {
      "content-type": "application/json",
    },
  ).then((response) async {
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (response.body == 'auth/email-already-in-use') {
        return 'Email already in use.';
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to login');
    }
  });
}
