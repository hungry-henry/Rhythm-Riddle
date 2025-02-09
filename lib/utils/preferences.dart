import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// 主题模式管理
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // 异步初始化主题模式
  Future<void> init() async {
    final darkMode = await Preferences.getDarkMode(); // 获取存储的主题模式
    _themeMode = darkMode == 1
        ? ThemeMode.dark
        : darkMode == 0
            ? ThemeMode.light
            : ThemeMode.system;
    notifyListeners();
  }

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    // 存储新的主题模式
    Preferences.setDarkMode(mode == ThemeMode.dark ? 1 : (mode == ThemeMode.light ? 0 : 2));
  }
}

// 偏好设置管理
class Preferences{
  static Future<dynamic> getSettings([String? setting]) async {
    final prefs = await SharedPreferences.getInstance();
    if (setting == null) {
      return prefs;
    }else{
      if(prefs.containsKey(setting)){
        return prefs.get(setting);
      }else{
        return null;
      }
    }
  }

  static Future<int> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('darkMode')){
      return prefs.getInt('darkMode')!;
    }else{ 
      // follow system
      prefs.setInt('darkMode', 2);
      return 2;
    }
  }

  static Future<void> setDarkMode(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('darkMode', value);
  }
}