import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/models/config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider with ChangeNotifier {
  ConfigModel? _config;
  bool _isLoading = false;
  String? _error;
  static const String _configKey = 'app_config';

  ConfigModel? get config => _config;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<bool> fetchConfig() async {
    if (_isLoading) return false;
    
    _setLoading(true);
    _error = null;

    try {
      final response = await http.get(
        Uri.parse('https://justb2c.grahaksathi.com/api/config'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          if (kDebugMode) {
            print('Parsed JSON data: $jsonData');
          }
          
          _config = ConfigModel.fromJson(jsonData);
          
          await SecureStorageService.saveConfig(_config!);
          
          // Store in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_configKey, response.body);
          
          _setLoading(false);
          return true;
        } catch (parseError) {
          if (kDebugMode) {
            print('JSON Parse Error: $parseError');
          }
          throw Exception('Failed to parse config: $parseError');
        }
      } else {
        throw Exception('Failed to load config: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in fetchConfig: $e');
      }
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loadStoredConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedConfig = prefs.getString(_configKey);
      
      if (storedConfig != null) {
        final Map<String, dynamic> jsonData = json.decode(storedConfig);
       _config = ConfigModel.fromJson(jsonData);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading stored config: $e');
      }
      _setError('Failed to load stored config');
      return false;
    }
  }
}