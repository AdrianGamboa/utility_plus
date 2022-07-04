import 'package:flutter/material.dart';

const colorPrimary = Colors.deepOrangeAccent;
const colorAccent = Colors.orange;

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: colorPrimary,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: colorAccent),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0))),
            backgroundColor: MaterialStateProperty.all<Color>(colorAccent))),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff707070),
          width: 1.0,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: colorAccent,
        ),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: colorAccent,
        ),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff707070),
          width: 1.0,
        ),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
    )),
    appBarTheme: const AppBarTheme(
      backgroundColor: colorAccent,
      elevation: 0,
    ));

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // ignore: deprecated_member_use
  accentColor: Colors.white,
  primaryColor: Colors.white,
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.all<Color>(Colors.grey),
    thumbColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff707070),
        width: 1.0,
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff707070),
        width: 1.0,
      ),
    ),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide.none),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black26))),
  buttonColor: Color(0xff707070),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  )),
  appBarTheme: const AppBarTheme(
    elevation: 0,
  ),
);
