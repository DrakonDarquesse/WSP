import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
      if (response.body == 'auth/wrong-password') {
        return 'Wrong password.';
      }

      if (response.body == 'auth/user-not-found') {
        return 'User not found.';
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', response.body);
    } else {
      throw Exception('Failed to login');
    }
  });
}

Future<String?> register(String email, String password, String name) async {
  const String api_url = 'http://localhost:3000/register';

  Map<String, String> body = {
    'email': email,
    'password': password,
    'name': name,
  };

  return await http.post(
    Uri.parse(api_url),
    body: jsonEncode(body),
    headers: {
      "content-type": "application/json",
    },
  ).then((response) async {
    if (response.statusCode == 200) {
      if (response.body == 'auth/email-already-in-use') {
        return 'Email already in use.';
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', response.body);
    } else {
      throw Exception('Failed to login');
    }
  });
}
