import 'dart:convert';
import 'package:app/models/exchange.dart';
import 'package:http/http.dart';

Future<List<Exchange>> fetchExchange() async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/exchanges';
  // const String api_url = 'http://localhost:3000/roleDecks';
  Response response = await get(
    Uri.parse(api_url),
  );

  print('asdfghjkl');
  if (response.statusCode == 200) {
    List<dynamic> roleDecks = jsonDecode(response.body)
        .map((data) => Exchange.fromJson(data))
        .toList();
    return roleDecks.cast<Exchange>();
  } else {
    throw Exception('Failed to load member');
  }
}

Future<void> addExchange(Exchange roleDeck) async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/addExchange';
  // const String api_url = 'http://localhost:3000/addExchange';

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

Future<void> editExchange(Exchange roleDeck) async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/editExchange';
  // const String api_url = 'http://localhost:3000/editExchange';

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

Future<void> deleteExchange(Exchange roleDeck) async {
  const String api_url =
      'https://afternoon-shore-55342.herokuapp.com/deleteExchange';
  // const String api_url = 'http://localhost:3000/deleteExchange';

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
