import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier{

  ThemeMode themeModee = ThemeMode.light;

  get themeMode => themeModee;

  toggleTheme(bool isDark){
    themeModee = isDark?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }
}