import 'dart:convert';
import 'package:app/models/member.dart';
import 'package:http/http.dart' as http;

Future<String> login(String email, String password) async {
  const String api_url = 'https://afternoon-shore-55342.herokuapp.com/login';
  // const String api_url = 'http://localhost:3000/login';

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
      return response.body;
    } else {
      throw Exception('Failed to login');
    }
  });
}

Future<String> register(String email, String password, String name) async {
  const String api_url = 'https://afternoon-shore-55342.herokuapp.com/register';
  // const String api_url = 'http://localhost:3000/register';

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
      return response.body;
    } else {
      throw Exception('Failed to login');
    }
  });
}

Future<dynamic> checkAuth() async {
  const String api_url = 'https://afternoon-shore-55342.herokuapp.com/check';
  // const String api_url = 'http://localhost:3000/register';

  return await http
      .post(
    Uri.parse(api_url),
  )
      .then((response) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  });
}

Future<dynamic> logout() async {
  const String api_url = 'https://afternoon-shore-55342.herokuapp.com/logout';
  // const String api_url = 'http://localhost:3000/register';

  return await http
      .post(
    Uri.parse(api_url),
  )
      .then((response) async {
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to login');
    }
  });
}
