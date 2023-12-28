class OrderModel {
  String product;
  int command_quantity;
  bool deliver_done;
  String date;

  OrderModel({
    required this.command_quantity,
    required this.date,
    required this.product,
    required this.deliver_done,
  });

  factory OrderModel.fromJson(dynamic json) {
    return OrderModel(
        command_quantity: json["command_quantity"],
        date: json["date"],
        product: json["product"],
        deliver_done: json["deliver_done"]);
  }
}
