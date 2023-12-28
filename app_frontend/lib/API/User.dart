// ignore: file_names
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

Future login(String email, password) async {
  Response response = await post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.Login),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
      },
      body: {
        'username': email,
        'password': password,
      });
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['access_token']);
    return 0;
  } else {
    return 1;
  }
}
