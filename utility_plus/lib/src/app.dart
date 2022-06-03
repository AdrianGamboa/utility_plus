import 'package:flutter/material.dart';
import 'package:utility_plus/src/screens/about_page.dart';
import 'package:utility_plus/src/screens/main_page.dart';
import 'package:utility_plus/src/screens/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Utility+', initialRoute: "/", routes: {
      "/": (BuildContext context) => const SplashPage(),
      "/main": (BuildContext context) => const MainPage(),
      "/about": (BuildContext context) => const AboutPage(),
    });
  }
}
