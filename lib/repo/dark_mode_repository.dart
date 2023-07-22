import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeRepository {
  static const _darkModeKey = 'dark_mode';

  Future<bool> isDarkMode() async {
    var prefs = await SharedPreferences.getInstance();
    var darkMode = prefs.getBool(_darkModeKey) ??
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    return darkMode;
  }

  Future<bool> toggleDarkMode() async {
    var currentMode = await isDarkMode();
    var prefs = await SharedPreferences.getInstance();
    var newValue = !currentMode;
    prefs.setBool(_darkModeKey, newValue);
    return newValue;
  }
}
