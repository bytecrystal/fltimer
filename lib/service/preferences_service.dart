import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String timeColorKey = 'timeColor';
  static const String titleTextKey = 'titleText';
  static const String textSizeKey = 'textSize';
  static const String showAppBarKey = 'showAppBar';
  static const String timeWidthKey = 'timeWidth';
  static const String timeHeightKey = 'timeHeight';
  static const String displayCurrentTimeKey = 'displayCurrentTime';
  static const String windowWidthKey = 'windowWidth';
  static const String windowHeightKey = 'windowHeight';


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

  Future<void> saveTimeWidthAndHeight(double timeWidth, double timeHeight) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setDouble(timeWidthKey, timeWidth);
    await prefs.setDouble(timeHeightKey, timeHeight);
  }

  Future<void> saveWindowSize(double width, double height) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setDouble(windowWidthKey, width);
    await prefs.setDouble(windowHeightKey, height);
  }

  Future<bool> loadShowAppBar() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(showAppBarKey) ?? true;
  }

  Future<double> loadTimeWidth() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble(timeWidthKey) ?? 54.0;
  }

  Future<double> loadTimeHeight() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble(timeHeightKey) ?? 84.0;
  }

  Future<double> loadWindowWidth() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble(windowWidthKey) ?? 600;
  }

  Future<double> loadWindowHeight() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble(windowHeightKey) ?? 280;
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
