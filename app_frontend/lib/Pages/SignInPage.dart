// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_frontend/Theme/Theme.dart';
import 'package:app_frontend/Provider/ModalHudProgress.dart';
import 'package:app_frontend/IconIllustrations/IconIllustrations.dart';
import 'package:app_frontend/Pages/SignUpPage.dart';
import 'package:app_frontend/API/User.dart';
import 'package:app_frontend/Pages/MainPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static String id = "SignIn";

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late String email_signIn, password_signIn;
  bool rememberMe = false;
  bool themeSwitch = false;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    void keepUserLoggedIn() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("rememberMe", rememberMe);
    }

    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<ModalHudProgress>(context).isLoading,
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18, top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: "Changer le thème",
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFFDB84),
                            fontFamily: "Montserrat",
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
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
                                borderRadius: BorderRadius.circular(30),
                              ),
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
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 220,
                    width: 220,
                    child: SvgPicture.asset(signIn),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Veuillez entrer un mail";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email_signIn = value!;
                      },
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        color: Color(0xff707070),
                      ),
                      decoration: const InputDecoration(
                          hintText: "Email",
                          contentPadding: EdgeInsets.only(left: 20),
                          hintStyle: TextStyle(
                            fontSize: 17,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 67,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Veuillez entrer un mot de passe";
                              // ignore: missing_return
                            }
                            return null;
                          },
                          onSaved: (value) {
                            password_signIn = value!;
                          },
                          obscureText: true,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                            color: Color(0xff707070),
                          ),
                          decoration: const InputDecoration(
                              hintText: "Mot de passe",
                              contentPadding: EdgeInsets.only(left: 20),
                              hintStyle: TextStyle(
                                fontSize: 17,
                                fontFamily: "Montserrat",
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          activeColor: Colors.black,
                          checkColor: const Color(0xffFFDB84),
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          }),
                      const Text(
                        "Rester connecté",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        if (rememberMe == true) {
                          keepUserLoggedIn();
                        }
                        final modalHud = Provider.of<ModalHudProgress>(context,
                            listen: false);
                        modalHud.changeIsLoading(true);
                        if (_globalKey.currentState!.validate()) {
                          _globalKey.currentState!.save();
                          if (await login(email_signIn, password_signIn) == 0) {
                            modalHud.changeIsLoading(false);
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                                context, MainPage.id, (route) => false);
                          } else {
                            modalHud.changeIsLoading(false);
                            // ignore: prefer_const_constructors
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.black,
                              content: const Center(
                                child: Text(
                                  "Identifiant ou mot de passe invalide",
                                  style: TextStyle(color: Color(0xffFFDB84)),
                                ),
                              ),
                              duration: const Duration(seconds: 4),
                            ));
                          }
                        }
                        modalHud.changeIsLoading(false);
                      },
                      child: Container(
                        height: 50,
                        width: 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xffFFDB84)),
                        child: const Center(
                          child: Text(
                            "Se connecter",
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
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Vous avez pas de compte?",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpPage.id);
                        },
                        child: const Text(
                          "S'inscrire",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff707070),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/adnantjeexx.png",
                        height: 25,
                        width: 25,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      const Text(
                        "Developpé par Adam Sebti",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
