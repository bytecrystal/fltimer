import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String timeColorKey = 'timeColor';
  static const String titleTextKey = 'titleText';
  static const String textSizeKey = 'textSize';
  static const String showAppBarKey = 'showAppBar';
  static const String displayCurrentTimeKey = 'displayCurrentTime';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveTimeColor(Color color) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(timeColorKey, color.value);
  }

  Future<Color> loadTimeColor() async {
    final SharedPreferences prefs = await _prefs;
    int? colorValue = prefs.getInt(timeColorKey);
    return colorValue != null ? Color(colorValue) : Colors.black;
  }

  Future<void> saveTitleText(String text) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(titleTextKey, text);
  }

  Future<String> loadTitleText() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(titleTextKey) ?? "";
  }

  Future<void> saveTextSize(double textSize) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setDouble(textSizeKey, textSize);
  }

  Future<double> loadTextSize() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble(textSizeKey) ?? 80.0;
  }

  Future<void> saveShowAppBar(bool showAppBar) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(showAppBarKey, showAppBar);
  }

  Future<bool> loadShowAppBar() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(showAppBarKey) ?? true;
  }

  Future<void> saveDisplayCurrentTime(bool displayCurrentTime) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(displayCurrentTimeKey, displayCurrentTime);
  }

  Future<bool> loadDisplayCurrentTime() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(displayCurrentTimeKey) ?? false;
  }

}
