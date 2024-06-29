// Packages
import 'package:flutter/material.dart';
import 'package:news_app/auth/onboarding_screen_page.dart';
import 'package:news_app/providers/bookmarks_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/services/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:news_app/screens/blog_details.dart';
import 'package:news_app/splashscreen.dart';
import 'package:provider/provider.dart';
// Screens
import 'package:firebase_core/firebase_core.dart';
// Const
import 'consts/theme_data.dart';
// Providers
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Need it to access the theme Provider
  ThemeProvider themeChangeProvider = ThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  // Fetch the current theme
  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    MainModel model = MainModel();

    return ScopedModel(
        model: model,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              // Notify about theme changes
              return themeChangeProvider;
            }),
            ChangeNotifierProvider(
              create: (_) => NewsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => BookmarksProvider(),
            )
          ],
          child:
              //Notify about theme changes
              Consumer<ThemeProvider>(
                  builder: (context, themeChangeProvider, ch) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Viral Newz',
              theme:
                  Styles.themeData(themeChangeProvider.getDarkTheme, context),
              home: SplashScreen(model),
              // HomeScreen(),
              routes: {
                '/onboard': (BuildContext context) => const OnboardingScreenPage(),
                NewsDetailsScreen.routeName: (context) => const NewsDetailsScreen(),
              },
            );
          }),
        ));
  }
}
