import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {

  bool isDark = true;

  void toggleTheme() {

    isDark = !isDark;

    notifyListeners();
  }
}