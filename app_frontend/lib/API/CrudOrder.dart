import 'constants.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_frontend/Model/foodModel.dart';

Future NewCommand(List<FoodModel> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  for (var item in list) {
    try {
      print(item.product);
      await post(Uri.parse(ApiConstants.baseUrl + ApiConstants.Command),
          headers: <String, String>{
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'product': item.product,
            'command_quantity': item.quantity.toString(),
          }));
    } catch (e) {
      print(e);
    }
  }
  print("okk");
}
