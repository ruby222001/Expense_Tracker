import 'package:flutter/material.dart';
import 'package:hive_practise/theme/dark.dart';
import 'package:hive_practise/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable ThemeData
  final Rx<ThemeData> _themeData = darkMode.obs;

  ThemeData get themeData => _themeData.value;

  bool get isDarkMode => _themeData.value == darkMode;

  void toggleTheme() {
    _themeData.value = _themeData.value == lightMode ? darkMode : lightMode;
  }

  void setTheme(ThemeData theme) {
    _themeData.value = theme;
  }
}
