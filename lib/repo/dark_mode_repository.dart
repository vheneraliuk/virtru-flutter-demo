import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeRepository {
  static const darkModeKey = 'dark_mode';

  Future<bool> isDarkMode() async {
    var prefs = await SharedPreferences.getInstance();
    var darkMode = prefs.getBool(darkModeKey) ??
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    return darkMode;
  }

  Future<bool> toggleDarkMode() async {
    var currentBrightness = await isDarkMode();
    var prefs = await SharedPreferences.getInstance();
    var newValue = !currentBrightness;
    prefs.setBool(darkModeKey, newValue);
    return newValue;
  }
}
