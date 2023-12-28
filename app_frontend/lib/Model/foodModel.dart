// ignore: file_names
class FoodModel {
  String product;
  String category;
  String image;
  String description;
  String nutrition;
  String buy_price;
  String sell_price;
  int quantity;

  FoodModel(
      {required this.image,
      required this.product,
      required this.description,
      required this.buy_price,
      required this.sell_price,
      required this.nutrition,
      required this.category,
      required this.quantity});

  factory FoodModel.fromJson(dynamic json) {
    return FoodModel(
        image: json["image"],
        product: json["product"],
        description: json["description"],
        buy_price: json["buy_price"].toString(),
        sell_price: json["sell_price"].toString(),
        nutrition: json["nutrition"],
        category: json["category"][0],
        quantity: 0);
  }
}
