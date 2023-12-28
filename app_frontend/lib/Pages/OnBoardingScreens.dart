// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app_frontend/IconIllustrations/IconIllustrations.dart';
import 'SignInPage.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({super.key});

  static String id = "OnBoardingScreens";

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: SvgPicture.asset(
            logo_app,
            height: 180,
            width: 180,
          )),
          const SizedBox(height: 40.0),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'COMIF APP',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              "Comif is love\nComif is life",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, SignInPage.id, (route) => false);
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xffFFDb84),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                CupertinoIcons.right_chevron,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
