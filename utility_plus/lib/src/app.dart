import 'package:flutter/material.dart';
import 'package:utility_plus/src/screens/about_page.dart';
import 'package:utility_plus/src/screens/accounts_page.dart';
import 'package:utility_plus/src/screens/finance_page.dart';
import 'package:utility_plus/src/screens/login_page.dart';
import 'package:utility_plus/src/screens/main_page.dart';
import 'package:utility_plus/src/screens/register_page.dart';
import 'package:utility_plus/src/screens/note_create_page.dart';
import 'package:utility_plus/src/screens/splash_page.dart';
import 'package:utility_plus/src/theme/theme_constants.dart';
import 'package:utility_plus/src/utils/global.dart';
import 'screens/recoverpass_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    themeManager.addListener(() {
      themeListener();
    });
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  takeTheme() {
    var hora = DateTime.now().hour;

    if (hora >= 6 && hora < 18) {
      themeManager.themeModee = ThemeMode.light;
    } else {
      themeManager.themeModee = ThemeMode.dark;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    takeTheme();
    return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeManager.themeMode,
        title: 'Utility+',
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => const SplashPage(),
          "/login": (BuildContext context) => const LoginPage(),
          "/main": (BuildContext context) => const MainPage(),
          "/about": (BuildContext context) => const AboutPage(),
          "/register": (BuildContext context) => const RegisterPage(),
          "/notecreate": (BuildContext context) => const NoteCreate(),
          "/recoverPass": (BuildContext context) => const RecoverPassPage(),
          "/accounts": (BuildContext context) => const AccountPage(),
        });
  }
}
