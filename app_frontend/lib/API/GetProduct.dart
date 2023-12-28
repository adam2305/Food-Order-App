import 'constants.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:app_frontend/Model/foodModel.dart';

Future get_product() async {
  List<FoodModel> foodModelList = [];
  try {
    Response response = await get(
      Uri.parse(ApiConstants.baseUrl + "/products"),
      headers: <String, String>{
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      List<FoodModel> foodModelList =
          list.map((e) => FoodModel.fromJson(e)).toList();
      return foodModelList;
    }
  } catch (err) {
    print(err);
  }
  return foodModelList;
}
