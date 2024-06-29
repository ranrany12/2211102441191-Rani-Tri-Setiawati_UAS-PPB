import 'package:flutter/material.dart';
import 'package:news_app/consts/global_colors.dart';
import 'package:news_app/screens/home_screen.dart';
// import 'package:kasirapp/main.dart';
import '../utils/pallete.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../transaksi_page.dart';
import './firebase_auth.dart';
import './validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return GestureDetector(
        onTap: () {
          _focusName.unfocus();
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
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Registrasi",
                        style: TextStyle(
                            fontSize: 40,
                            color: ConstColors.whiteFontColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Masukkan data yang benar",
                        style: TextStyle(
                            fontSize: 14,
                            color: ConstColors.whiteFontColor,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ))),
          body: Container(
            // padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.all(24),
                      child: Form(
                        key: _registerFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameTextController,
                              focusNode: _focusName,
                              cursorColor: darkBackgroundColor,
                              validator: (value) => Validator.validateName(
                                name: value,
                              ),
                              style: TextStyle(color: darkBackgroundColor),
                              decoration: InputDecoration(
                                hintText: "Nama Lengkap",
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
                              style: TextStyle(color: darkBackgroundColor),
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) => Validator.validateEmail(
                                email: value,
                              ),
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
                              style: TextStyle(color: darkBackgroundColor),
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: true,
                              cursorColor: darkBackgroundColor,
                              validator: (value) => Validator.validatePassword(
                                password: value,
                              ),
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
                            const SizedBox(height: 60.0),
                            _isProcessing
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        darkBackgroundColor))
                                : Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              _isProcessing = true;
                                            });

                                            if (_registerFormKey.currentState!
                                                .validate()) {
                                              User? user =
                                                  await FirebaseAuthHelper
                                                      .registerUsingEmailPassword(
                                                name: _nameTextController.text,
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
                                                    backgroundColor: Colors.red,
                                                    duration:
                                                        Duration(seconds: 4),
                                                    behavior:
                                                        SnackBarBehavior.fixed,
                                                    content: Text(
                                                      "Email yang dimasukkan telah digunakan.",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          height: 1.4,
                                                          color: Colors.white),
                                                    ));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            } else {
                                              setState(() {
                                                _isProcessing = false;
                                              });
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
                                                    Color>(darkBackgroundColor),
                                          ),
                                          child: const Text(
                                            "Daftar",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    ConstColors.whiteFontColor),
                                          ),
                                        ),
                                      )),
                                    ],
                                  )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
