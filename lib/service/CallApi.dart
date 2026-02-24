import 'package:http/http.dart' as http;
import 'package:momensalman/Model/Users.dart';
import 'dart:convert';

class CallApi {
  static Future<List<Usersfromjson>> getUsers() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      return usersfromjsonFromJson(response.body);
    } else {
      throw Exception('Failed to load users');
    }




  }
}


