// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData? _selectTheme;

  ThemeData light = ThemeData.light().copyWith(
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xffFFFAEE),
      ),
      dialogBackgroundColor: const Color(0xffFFFAEE),
      dialogTheme: const DialogTheme(
          titleTextStyle: TextStyle(
        color: Color(0xff544646),
      )),
      scaffoldBackgroundColor: const Color(0xffFFFAEE),
      appBarTheme: const AppBarTheme(color: Color(0xffFFFAEE)),
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: Color(0xff544646)),
        bodyText2: TextStyle(color: Color(0xff544646)),
      ),
      cardTheme: const CardTheme(
        color: Color(0xfffff0c4),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: const Color(0xff212226)));

  ThemeData dark = ThemeData.dark().copyWith(
    dialogBackgroundColor: const Color(0xff212226),
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(color: Color(0xffFFDB84)),
    ),

    scaffoldBackgroundColor: const Color(0xff121417),
    appBarTheme: const AppBarTheme(
      color: Color(0xff121417),
    ),
    cardTheme: const CardTheme(color: Color(0xff212226)),

    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Color(0xffFFDB84)),
      bodyText2: TextStyle(color: Color(0xffFFDB84)),
    ),

    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff212226)),

    // primaryColor: Color(0xff212429),
  );

  ThemeProvider({bool? isDarkMode}) {
    try {
      if (isDarkMode == null) {
        _selectTheme = light;
      } else {
        _selectTheme = isDarkMode ? dark : light;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> swapTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_selectTheme == dark) {
      _selectTheme = light;
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark));
      preferences.setBool("isDarkTheme", false);
    } else {
      _selectTheme = dark;
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light));
      preferences.setBool("isDarkTheme", true);
    }
    notifyListeners();
  }

  ThemeData? get getTheme => _selectTheme;
}
