import 'package:flutter/material.dart';
import 'package:app_frontend/Provider/ModalHudProgress.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_frontend/IconIllustrations/IconIllustrations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static String id = "SignUp";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late String email_signUp, password_signUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHudProgress>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  height: 220,
                  width: 220,
                  child: SvgPicture.asset(
                    signUp,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Veuillez entrer un mail";
                        // ignore: missing_return
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email_signUp = value!;
                    },
                    autocorrect: true,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                      color: Color(0xff707070),
                      // color: Color(0xff544646)
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
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 67,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is empty";
                            // ignore: missing_return
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password_signUp = value!;
                        },
                        obscureText: true,
                        autocorrect: true,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat",
                          color: Color(0xff707070),
                          // color: Color(0xff544646)
                        ),
                        decoration: const InputDecoration(
                            hintText: "Password",
                            contentPadding: EdgeInsets.only(left: 20),
                            hintStyle: TextStyle(
                                fontSize: 17, fontFamily: "Montserrat"),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () async {
                      final modalHud =
                          Provider.of<ModalHudProgress>(context, listen: false);
                      modalHud.changeIsLoading(true);

                      if (_globalKey.currentState!.validate()) {
                        // sign up user info to firebase auth
                        try {
                          _globalKey.currentState!.save();
                          //inserer code pour faire requete HTTP
                          modalHud.changeIsLoading(false);
                          Navigator.of(context).pop();
                        } catch (e) {
                          modalHud.changeIsLoading(false);
                          // afficher les erreurs
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
                          "Sign Up",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
