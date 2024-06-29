import 'package:flutter/material.dart';
import 'package:news_app/consts/global_colors.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
import '../../utils/pallete.dart';

class OnboardingScreenPage extends StatefulWidget {
  const OnboardingScreenPage({super.key});

  @override
  State<OnboardingScreenPage> createState() => _OnboardingScreenPageState();
}

class _OnboardingScreenPageState extends State<OnboardingScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 250,
                      child: Image.asset(
                        'assets/images/newspaper.png',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Viral Newz",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: ConstColors.whiteFontColor),
                    )
                  ],
                )),
            Expanded(
                flex: 1,
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Container(
                                  child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const LoginScreen()));
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.grey[300]!),
                                ),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ConstColors.textColor),
                                )),
                          ))),
                          const SizedBox(width: 15),
                          Expanded(
                              child: Container(
                                  child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const SignUpScreen()));
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.grey[300]!),
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ConstColors.textColor),
                                )),
                          ))),
                        ]))),
          ],
        ),
      ),
    );
  }
}
