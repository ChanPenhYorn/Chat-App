import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/utils/app_theme.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var currentThemeIndex = 0.obs;

  final List<ThemeData> themes = [
    AppThemes.lightTheme,
    AppThemes.darkTheme,
  ];

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPreferences();
  }

  Future<void> _loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentThemeIndex.value = prefs.getInt('currentThemeIndex') ?? 0;
  }

  void toggleTheme() async {
    currentThemeIndex.value = (currentThemeIndex.value + 1) % themes.length;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentThemeIndex', currentThemeIndex.value);
  }

  ThemeData get currentTheme => themes[currentThemeIndex.value];
}
