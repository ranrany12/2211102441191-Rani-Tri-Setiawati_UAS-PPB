import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app/consts/global_colors.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
// import 'package:kasirapp/main.dart';`
// import 'package:sji_info/screens/home_screen.dart';
import './signup_screen.dart';
import '../utils/pallete.dart';
import './firebase_auth.dart';
import './validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(
      //       user: user,
      //     ),
      //   ),
      // );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return GestureDetector(
        onTap: () {
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          backgroundColor: ConstColors.whiteFontColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(120.0),
              child: Container(
                  color: darkBackgroundColor,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 20),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 40,
                        color: ConstColors.whiteFontColor,
                        fontWeight: FontWeight.bold),
                  ))),
          body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(left: 24.0, right: 24.0, top: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 150,
                      //   width: 150,
                      //   child: Image.asset("sji_logo.png"),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(bottom: 30.0, top: 12),
                      //   child: Text('Welcome to SJI',
                      //       style: TextStyle(color: Colors.black, fontSize: 40)),
                      // ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) => Validator.validateEmail(
                                email: value,
                              ),
                              style: TextStyle(color: darkBackgroundColor),
                              cursorColor: darkBackgroundColor,
                              decoration: InputDecoration(
                                hintText: "Email",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: darkBackgroundColor,
                                        width: 2,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        style: BorderStyle.solid)),
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        style: BorderStyle.solid)),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14.0),
                            TextFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: true,
                              cursorColor: darkBackgroundColor,
                              validator: (value) => Validator.validatePassword(
                                password: value,
                              ),
                              style: TextStyle(color: darkBackgroundColor),
                              decoration: InputDecoration(
                                hintText: "Password",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: darkBackgroundColor,
                                        width: 2,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        style: BorderStyle.solid)),
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        style: BorderStyle.solid)),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
                            _isProcessing
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        darkBackgroundColor))
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          height: 60,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              _focusEmail.unfocus();
                                              _focusPassword.unfocus();

                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isProcessing = true;
                                                });

                                                User? user =
                                                    await FirebaseAuthHelper
                                                        .signInUsingEmailPassword(
                                                  email:
                                                      _emailTextController.text,
                                                  password:
                                                      _passwordTextController
                                                          .text,
                                                );

                                                setState(() {
                                                  _isProcessing = false;
                                                });

                                                if (user != null) {
                                                  //
                                                  model.setLoggedData(
                                                      user.uid,
                                                      user.email!,
                                                      user.displayName!);
                                                  await model.saveToSqlite(
                                                      user.displayName!,
                                                      user.email!,
                                                      user.uid);
                                                  //
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomeScreen()
                                                        // MyHomePage(
                                                        //     model,
                                                        //     user.uid,
                                                        //     user.displayName!),
                                                        ),
                                                    ModalRoute.withName('/'),
                                                  );
                                                } else {
                                                  const snackBar = SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      duration:
                                                          Duration(seconds: 4),
                                                      behavior: SnackBarBehavior
                                                          .fixed,
                                                      content: Text(
                                                        "Email atau Password anda salah.",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            height: 1.4,
                                                            color:
                                                                Colors.white),
                                                      ));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              }
                                            },
                                            style: ButtonStyle(
                                              shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              )),
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                          Color>(
                                                      darkBackgroundColor),
                                            ),
                                            child: const Text(
                                              "Masuk",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstColors
                                                      .whiteFontColor),
                                            ),
                                          )),
                                      const SizedBox(width: 24.0),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpScreen(),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  ConstColors.whiteFontColor),
                                        ),
                                        child: const Text(
                                          'Registrasi',
                                          style: TextStyle(
                                              color: ConstColors.textColor,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(darkBackgroundColor)),
              );
            },
          ),
        ),
      );
    });
  }
}
