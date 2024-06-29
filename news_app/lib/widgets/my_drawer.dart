import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:news_app/auth/onboarding_screen_page.dart';
import 'package:news_app/providers/theme_provider.dart';
import 'package:news_app/screens/bookmark_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/widgets/my_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../services/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MyDrawerWidget extends StatefulWidget {
  const MyDrawerWidget({super.key});

  @override
  State<MyDrawerWidget> createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Drawer(
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/newspaper.png',
                      width: 90,
                      height: 90,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ViralNewz',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          MyListTileWidget(
                            title: 'Home',
                            icon: IconlyBold.home,
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const HomeScreen(),
                                ),
                              );
                            },
                          ),
                          MyListTileWidget(
                            title: 'Bookmarks',
                            icon: IconlyBold.bookmark,
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const BookmarkScreen(),
                                ),
                              );
                            },
                          ),
                          MyListTileWidget(
                            title: 'Logout',
                            icon: IconlyBold.logout,
                            onTap: () {
                              Navigator.of(context).pop();
                              Logout(model);
                            },
                          ),
                        ],
                      ),
                      SwitchListTile(
                        title: Text(
                          themeProvider.getDarkTheme ? 'Dark' : 'Light',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor,
                          ),
                        ),
                        secondary: Icon(
                          themeProvider.getDarkTheme
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        value: themeProvider.getDarkTheme,
                        onChanged: (bool value) {
                          setState(() {
                            themeProvider.setDarkTheme = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<dynamic> Logout(MainModel model) async {
    await FirebaseAuth.instance.signOut();
    model.logout();
    model.clearComments();
    model.clearUser();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreenPage(),
      ),
    );
  }
}
