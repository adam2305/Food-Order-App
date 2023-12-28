// Importing important packages require to connect
// Flutter and Dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'Theme/Theme.dart';
import 'Pages/OnBoardingScreens.dart';
import 'Pages/SignInPage.dart';
import 'Pages/SignUpPage.dart';
import 'package:app_frontend/Provider/CartItem.dart';
import 'package:app_frontend/Provider/ModalHudProgress.dart';
import 'package:app_frontend/Pages/MainPage.dart';
import 'package:app_frontend/Pages/FoodDetails.dart';
import 'package:app_frontend/Pages/CartPage.dart';

bool? rememberMe = false;

// Main Function
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  rememberMe = preferences.getBool("rememberMe");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CartItems>(
        create: (context) => CartItems(),
      ),
      ChangeNotifierProvider<ModalHudProgress>(
        create: (context) => ModalHudProgress(),
      ),
    ],
    child: ChangeNotifierProvider(
        create: (context) =>
            ThemeProvider(isDarkMode: preferences.getBool("isDarkTheme")),
        child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<ThemeProvider>(builder: (context, themProvider, child) {
      return MaterialApp(
        theme: themProvider.getTheme,
        debugShowCheckedModeBanner: false,
        // OnBoarding open one time

        initialRoute: rememberMe == true ? MainPage.id : OnBoardingScreens.id,
        routes: {
          OnBoardingScreens.id: (context) => const OnBoardingScreens(),
          SignInPage.id: (context) => const SignInPage(),
          SignUpPage.id: (context) => const SignUpPage(),
          MainPage.id: (context) => const MainPage(),
          FoodDetails.id: (context) => const FoodDetails(),
          CartPage.id: (context) => CartPage(),
        },
      );
    });
  }
}
