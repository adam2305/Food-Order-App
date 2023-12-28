import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import 'package:app_frontend/IconIllustrations/IconIllustrations.dart';
import 'package:app_frontend/Provider/CartItem.dart';

import 'Home.dart';
import 'CartPage.dart';
import 'Profile.dart';
import 'OrderTracking.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static String id = "MainPage";

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const Home(),
    const OrderTracking(),
    const CartPage(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    var cartFood = Provider.of<CartItems>(context);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: _pages.elementAt(_selectedIndex),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 11, left: 11),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black87,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GNav(
                      curve: Curves.easeOutExpo,
                      gap: 5,
                      color: const Color(0xffFFDB84),
                      activeColor: Colors.black,
                      iconSize: 30,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6.7),
                      duration: const Duration(milliseconds: 200),
                      tabBackgroundColor: const Color(0xffFFDB84),
                      tabs: [
                        const GButton(
                          icon: Icons_foodApp.home,
                          text: 'Home',
                          textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontFamily: "Montserrat"),
                        ),
                        GButton(
                          icon: Icons_foodApp.order,
                          text: 'Commandes',
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontFamily: "Montserrat"),
                          ////// insereer verification commandes API
                          leading: _selectedIndex == 1
                              ? null
                              : badges.Badge(
                                  badgeAnimation:
                                      const badges.BadgeAnimation.slide(
                                          animationDuration:
                                              Duration(milliseconds: 400)),
                                  badgeStyle: const badges.BadgeStyle(
                                    elevation: 0,
                                    badgeColor: Color(0xffff124d),
                                  ),
                                  position: badges.BadgePosition.topEnd(
                                      top: -3, end: -2),
                                  child: const Icon(
                                    Icons_foodApp.order,
                                    size: 30,
                                    color: Color(0xffFFDB84),
                                  ),
                                ),
                        ),
                        GButton(
                          text: 'Panier',
                          icon: Icons_foodApp.cart,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontFamily: "Montserrat"),
                          leading:
                              _selectedIndex == 2 || cartFood.itemCount == 0
                                  ? null
                                  : badges.Badge(
                                      badgeAnimation:
                                          const badges.BadgeAnimation.slide(
                                              animationDuration:
                                                  Duration(milliseconds: 400)),
                                      badgeStyle: const badges.BadgeStyle(
                                        elevation: 0,
                                        badgeColor: Color(0xffff124d),
                                      ),
                                      position:
                                          badges.BadgePosition.topEnd(top: -12),
                                      badgeContent: Text(
                                        cartFood.itemCount.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      child: const Icon(
                                        Icons_foodApp.cart,
                                        color: Color(0xffFFDB84),
                                      ),
                                    ),
                        ),
                        const GButton(
                          icon: Icons_foodApp.profile,
                          text: 'Profil',
                          textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontFamily: "Montserrat"),
                        ),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
