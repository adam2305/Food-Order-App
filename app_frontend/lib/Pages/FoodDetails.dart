import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_frontend/Model/foodModel.dart';
import 'package:app_frontend/API/constants.dart';
import 'package:app_frontend/IconIllustrations/IconIllustrations.dart';
import 'package:app_frontend/Provider/CartItem.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({super.key});
  static String id = "foodDetails";

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  bool isPressed = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    FoodModel foodModel =
        ModalRoute.of(context)?.settings.arguments as FoodModel;

    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        // color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodModel.product,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      foodModel.description,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff707070),
                          fontFamily: "Montserrat"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Price",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${foodModel.sell_price}",
                      style: const TextStyle(
                          fontSize: 35,
                          color: Color(0xff0A9400),
                          fontFamily: "Montserrat"),
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: SizedBox(
                      height: 160,
                      width: 75,
                      child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              foodModel.nutrition,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xff4a4a4a),
                              ),
                            ),
                          )),
                    ),
                  ),
                  Positioned(
                      right: -80,
                      bottom: -90,
                      child: SizedBox(
                        height: 330,
                        width: 330,
                        child: Hero(
                          tag: foodModel.image,
                          child: CachedNetworkImage(
                            imageUrl:
                                "${ApiConstants.baseUrl}/static/product/${foodModel.image}",
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                      ))
                ],
              ),

              // ========================== Counter box for Foods ========================
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xffFFDB84)),
                      child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              if (quantity != 1) {
                                quantity--;
                              }
                            });
                          }),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat"),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xffFFDB84)),
                      child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        addToCart(context, foodModel);
                      },
                      child: SizedBox(
                        height: 60,
                        width: 180,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: Text(
                                  "add to cart",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: const Color(0xffFFDB84)),
                                    child: const Icon(Icons_foodApp.cart,
                                        size: 21, color: Color(0xff544646))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "INGREDIENTS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      foodModel.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xff707070),
                        fontFamily: "Montserrat",
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "NUTRITION",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      foodModel.nutrition,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xff707070),
                        fontFamily: "Montserrat",
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void addToCart(context, FoodModel fdModel) {
    print("function called");
    CartItems cartItem = Provider.of<CartItems>(context, listen: false);
    fdModel.quantity = quantity;
    bool exist = false;
    var foodInCart = cartItem.foodModel;
    for (var fdInCart in foodInCart) {
      if (fdInCart.product == fdModel.product) {
        exist = true;
        break;
      }
    }
    if (exist) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          "this food is already in cart",
          style: TextStyle(color: Color(0xffFFDB84)),
        ),
        duration: Duration(seconds: 3),
      ));
    } else {
      cartItem.addFood(fdModel);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          "Item Added to Cart",
          style: TextStyle(color: Color(0xffFFDB84)),
        ),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
