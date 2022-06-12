import 'package:flutter/material.dart';
import 'package:utility_plus/src/screens/about_page.dart';
import 'package:utility_plus/src/screens/login_page.dart';
import 'package:utility_plus/src/screens/main_page.dart';
import 'package:utility_plus/src/screens/register_page.dart';
import 'package:utility_plus/src/screens/note_create_page.dart';
import 'package:utility_plus/src/screens/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Utility+', initialRoute: "/", routes: {
      "/": (BuildContext context) => const SplashPage(),
      "/login": (BuildContext context) => const LoginPage(),
      "/main": (BuildContext context) => const MainPage(),
      "/about": (BuildContext context) => const AboutPage(),
      "/register": (BuildContext context) => const RegisterPage(),
      "/notecreate": (BuildContext context) => const NoteCreate(),
    });
  }
}
