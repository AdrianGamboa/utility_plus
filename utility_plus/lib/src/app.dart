import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utility_plus/src/screens/about_page.dart';
import 'package:utility_plus/src/screens/accounts_page.dart';
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
    initStorage();
    themeManager.addListener(() {
      themeListener();
    });
    super.initState();
  }

  initStorage() {
    if (GetStorage().read('theme') == null) {
      GetStorage().write('theme', 'auto');
    }
  }

  themeListener() {
    takeTheme();
    if (mounted) {
      setState(() {});
    }
  }

  takeTheme() {
    if (GetStorage().read('theme') == 'auto') {
      var hora = DateTime.now().hour;

      if (hora >= 6 && hora < 18) {
        themeManager.themeModee = ThemeMode.light;
      } else {
        themeManager.themeModee = ThemeMode.dark;
      }
    } else if (GetStorage().read('theme') == 'dark') {
      themeManager.themeModee = ThemeMode.dark;
    } else {
      themeManager.themeModee = ThemeMode.light;
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
