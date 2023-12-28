import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:app_frontend/Theme/Theme.dart';
import 'package:app_frontend/IconIllustrations/IconIllustrations.dart';
import 'package:app_frontend/Pages/SignInPage.dart';
import 'package:app_frontend/Model/foodModel.dart';
import 'package:app_frontend/API/GetProduct.dart';
import 'package:app_frontend/API/constants.dart';
import 'package:app_frontend/Pages/FoodDetails.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FoodModel> _list = [];
  late Future<List<FoodModel>> future_list;
  bool themeSwitch = false;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(165),
          child: Padding(
            padding: const EdgeInsets.only(top: 27),
            child: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Comif",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    fontFamily: "Montserrat"
                                    // color: Color(0xff544646),
                                    ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Commandez & Mangez",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xff707070),
                                    fontFamily: "Montserrat"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: [
                              Tooltip(
                                message: "Changer le thème",
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFFDB84),
                                    fontFamily: "Montserrat"),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(6)),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      themeSwitch = !themeSwitch;
                                      themeProvider.swapTheme();
                                    });
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFFDB84),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: themeSwitch
                                          ? const Icon(
                                              Icons_foodApp.dark_mode,
                                              size: 20,
                                              color: Colors.black,
                                            )
                                          : const Icon(
                                              Icons_foodApp.white_mode,
                                              size: 20,
                                              color: Colors.black,
                                            )),
                                ),
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Tooltip(
                                message: "Se deconnecter",
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
                                      builder: (BuildContext context) =>
                                          BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 4, sigmaY: 4),
                                        child: AlertDialog(
                                          title: const Text(
                                            "Se déconnecter",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                          content: const Text(
                                            "Vous êtes sûr ?",
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
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text(
                                                  "NON",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff707070),
                                                      fontFamily: "Montserrat"),
                                                )),
                                            TextButton(
                                                onPressed: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.clear();
                                                  // Sign out function API
                                                  // ignore: use_build_context_synchronously
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          SignInPage.id,
                                                          (route) => false);
                                                },
                                                child: const Text(
                                                  "OUI",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff707070),
                                                      fontFamily: "Montserrat"),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffFFDB84),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Icon(
                                      Icons_foodApp.logout,
                                      size: 19,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TabBar(
                    isScrollable: true,
                    indicatorWeight: 6,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: Color(0xffFFDB84),
                        width: 4,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 17),
                    ),
                    labelPadding: const EdgeInsets.all(10),
                    tabs: [
                      Tab(
                        child: SvgPicture.asset(
                          icon_burger,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      Tab(
                        child: SvgPicture.asset(
                          icon_pizza,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      Tab(
                        child: SvgPicture.asset(
                          icon_keto,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      Tab(
                        child: SvgPicture.asset(
                          icon_leanAndMean,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      Tab(
                        child: SvgPicture.asset(
                          icon_paleo,
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            foodView("VINS"),
            foodView("SOFTS"),
            foodView("VIENN"),
            foodView("APERITIFS"),
            foodView("BIERES"),
          ],
        ),
      ),
    );
  }

  Widget foodView(String nameCategory) {
    return FutureBuilder(
        future: get_product(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<FoodModel> _foodModel = [];
            _list = snapshot.data! as List<FoodModel>;
            _foodModel.clear();
            _foodModel = getFoodByCategory(nameCategory);
            return GridView.builder(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 80),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.72),
                itemCount: _foodModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, FoodDetails.id,
                          arguments: _foodModel[index]);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: _foodModel[index].product,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${ApiConstants.baseUrl}/static/product/${_foodModel[index].image}",
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                ),
                                height: 100,
                                width: 100,
                              ),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            SizedBox(
                              width: 110,
                              child: Text(
                                _foodModel[index].product,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // color: Color(0xff544646),
                                    fontSize: 18,
                                    fontFamily: "Montserrat"),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              _foodModel[index].category,
                              style: const TextStyle(
                                  color: Color(0xff707070),
                                  fontFamily: "Montserrat"),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              "\$${_foodModel[index].sell_price}",
                              style: const TextStyle(
                                  color: Color(0xff0A9400),
                                  fontSize: 20,
                                  fontFamily: "Montserrat"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
                child: SpinKitRipple(
              size: 70,
              color: Color(0xffFFDB84),
            ));
          }
        });
  }

  List<FoodModel> getFoodByCategory(String foodCategory) {
    List<FoodModel> _foodModel = [];
    try {
      for (var food in _list) {
        if (food.category == foodCategory) {
          _foodModel.add(food);
        }
      }
    } on Error catch (ex) {
      print(ex);
    }
    return _foodModel;
  }
}
