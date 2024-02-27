import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/use_config.dart';

// 创建一个单例类来封装SharedPreferences的操作
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  late SharedPreferences _prefs;

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 通用的获取方法
  dynamic get(String key) {
    return _prefs.get(key);
  }

  // 通用的存储方法, 支持基础类型以及List<String>
  Future<void> set(String key, dynamic value) async {
    if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw Exception('Invalid type');
    }
  }

  // 特定对象的设置与获取
  Future<void> setUserConfig(UserConfig userConfig) async {
    String userConfigJson = json.encode(userConfig.toJson());
    await _prefs.setString('userConfig', userConfigJson);
  }

  UserConfig? getUserConfig() {
    String? userJson = _prefs.getString('userConfig');
    if (userJson == null) return UserConfig.defaultConfig();
    return UserConfig.fromJson(json.decode(userJson));
  }

  // 清除方法
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
