import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iostest/models/config_model.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
    static const String _configKey = 'config_data';

  // Save auth token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Save user data
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(key: _userKey, value: json.encode(userData));
  }

  // Save both token and user data
  static Future<void> saveAuthData(String token, Map<String, dynamic> userData) async {
    await Future.wait([
      saveToken(token),
      saveUser(userData),
    ]);
  }

  // Get auth token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUser() async {
    final userStr = await _storage.read(key: _userKey);
    if (userStr != null) {
      return json.decode(userStr);
    }
    return null;
  }




   static Future<void> saveConfig(ConfigModel config) async {
    await _storage.write(
      key: _configKey,
      value: json.encode(config.toJson()),
    );
  }

  // Get config data
  static Future<ConfigModel?> getConfig() async {
    final configStr = await _storage.read(key: _configKey);
    if (configStr != null) {
      final configMap = json.decode(configStr);
      return ConfigModel.fromJson(configMap);
    }
    return null;
  }

  // Delete config
  static Future<void> deleteConfig() async {
    await _storage.delete(key: _configKey);
  }
  

  // Delete all stored data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}