import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:decimal/decimal.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app_frontend/Provider/CartItem.dart';
import 'package:app_frontend/Model/foodModel.dart';
import 'package:app_frontend/IconIllustrations/IconIllustrations.dart';
import 'package:app_frontend/Pages/FoodDetails.dart';
import 'package:app_frontend/API/constants.dart';
import 'package:app_frontend/API/CrudOrder.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  static String id = "cartPage";
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Decimal getTotalPrice(List<FoodModel> foodModel) {
    var price = Decimal.fromInt(0);
    for (var food in foodModel) {
      price += ((Decimal.parse(double.parse(food.sell_price).toString()) *
          Decimal.parse(food.quantity.toString())));
    }
    return price;
  }

  int getTotalQuantity(List<FoodModel> foodModel) {
    var allQuantity = 0;

    for (var quantity in foodModel) {
      allQuantity += quantity.quantity;
    }
    return allQuantity;
  }

  @override
  Widget build(BuildContext context) {
    List<FoodModel> cartFood = Provider.of<CartItems>(context).foodModel;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Cart of Foods",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"
                        // color: Color(0xff544646)
                        ),
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: "Delete All",
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFFDB84),
                            fontFamily: "Montserrat"),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6)),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext contex) =>
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 4, sigmaY: 4),
                                      child: AlertDialog(
                                        title: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                          ),
                                        ),
                                        content: const Text(
                                          "Do you want delete All foods?",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Montserrat",
                                            color: Color(0xff707070),
                                          ),
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text(
                                                "NO",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff707070),
                                                    fontFamily: "Montserrat"),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                                Provider.of<CartItems>(context,
                                                        listen: false)
                                                    .deleteAllFoods();
                                              },
                                              child: const Text(
                                                "YES",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff707070),
                                                    fontFamily: "Montserrat"),
                                              ))
                                        ],
                                      ),
                                    ));
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100)),
                            child: const Icon(
                              Icons_foodApp.delete,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Tooltip(
                        message: "CheckOut",
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFFDB84),
                            fontFamily: "Montserrat"),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6)),
                        child: GestureDetector(
                          onTap: () {
                            mainBottomSheet(context, cartFood);
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100)),
                            child: const Icon(
                              Icons_foodApp.order,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: cartFood.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: 260,
                            width: 260,
                            child: SvgPicture.asset(cart_empty)),
                        const Text(
                          "No foods yet",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat"
                              // color: Color(0xff544646)
                              ),
                        )
                      ],
                    )
                  : ListView.builder(
                      itemCount: cartFood.length,
                      itemBuilder: (context, index) => Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, FoodDetails.id,
                                    arguments: cartFood[index]);
                              },
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 4, sigmaY: 4),
                                          child: AlertDialog(
                                            title: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat",
                                              ),
                                            ),
                                            content: const Text(
                                              "Do you want delete this food?",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff707070),
                                                  fontFamily: "Montserrat"),
                                            ),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: const Text(
                                                    "No",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff707070),
                                                        fontFamily:
                                                            "Montserrat"),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    Provider.of<CartItems>(
                                                            context,
                                                            listen: false)
                                                        .deleteFood(
                                                            cartFood[index]);
                                                  },
                                                  child: const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff707070),
                                                        fontFamily:
                                                            "Montserrat"),
                                                  ))
                                            ],
                                          ),
                                        ));
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                    top: 10, left: 80, right: 20, bottom: 20),
                                height: 130,
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              cartFood[index].product,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  fontFamily: "Montserrat"),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            cartFood[index].category,
                                            style: const TextStyle(
                                                color: Color(0xff707070),
                                                fontFamily: "Montserrat"),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              "\$${Decimal.parse((double.parse(cartFood[index].sell_price)).toString()) * Decimal.parse(cartFood[index].quantity.toString())}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff0A9400),
                                                  fontSize: 17,
                                                  fontFamily: "Montserrat"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 7, right: 7),
                                          child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color:
                                                      const Color(0xffFFDB84)),
                                              child: Center(
                                                child: Text(
                                                  "${cartFood[index].quantity}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontFamily: "Montserrat"),
                                                ),
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            top: 15,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${ApiConstants.baseUrl}/static/product/${cartFood[index].image}",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ),
                              height: 120,
                              width: 120,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }

  mainBottomSheet(BuildContext context, List<FoodModel> foodModel) {
    var TotalPrice = getTotalPrice(foodModel);

    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons_foodApp.order,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Checkout",
                            style: TextStyle(
                                fontSize: 18, fontFamily: "Montserrat"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Card(
                                elevation: 0,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Total",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat"),
                                    ),
                                    const Text(
                                      "Price",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat"),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "\$",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff0A9400),
                                              fontFamily: "Montserrat"),
                                        ),
                                        Text(
                                          // ignore: unnecessary_null_comparison
                                          TotalPrice == null
                                              ? "0"
                                              : "$TotalPrice",
                                          style: const TextStyle(
                                              fontSize: 23,
                                              color: Color(0xff707070),
                                              fontFamily: "Montserrat"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Card(
                                elevation: 0,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Total",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat"),
                                    ),
                                    const Text(
                                      "Quantity",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat"),
                                    ),
                                    Text(
                                      "${getTotalQuantity(foodModel)}",
                                      style: const TextStyle(
                                          fontSize: 23,
                                          color: Color(0xff707070),
                                          fontFamily: "Montserrat"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 110,
                              width: 110,
                              child: Card(
                                elevation: 0,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Shipping",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat"),
                                    ),
                                    Text(
                                      "Price",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat"),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "\$",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff0A9400),
                                              fontFamily: "Montserrat"),
                                        ),
                                        Text(
                                          "test",
                                          style: TextStyle(
                                              fontSize: 23,
                                              color: Color(0xff707070),
                                              fontFamily: "Montserrat"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          CircularProgressIndicator();
                          //await NewCommand(foodModel);
                          //Provider.of<CartItems>(context, listen: false)
                          //    .deleteAllFoods();
                          //Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 80, left: 80),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xffFFDB84)),
                            child: const Center(
                              child: Text(
                                "Place Order",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: "Montserrat"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }
}
