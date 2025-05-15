import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/apiservice/setheader.dart';
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/models/gold_profile_model.dart';

class GoldProfileProvider extends ChangeNotifier {
  GoldProfileResponse? _goldProfile;
  bool _isLoading = false;

  GoldProfileResponse? get goldProfile => _goldProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchGoldProfile() async {
    final url = UrlConstants.goldProfile;

    _isLoading = true;
    notifyListeners();

    try {
      final headers = await SetHeaderHttps.setHttpheader(); // ✅ Centralized header

      if (kDebugMode) {
        print('Fetching gold profile from $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _goldProfile = GoldProfileResponse.fromJson(data);
      } else {
        throw Exception("Failed to load gold profile (Status ${response.statusCode})");
      }
    } catch (error) {
      if (kDebugMode) {
        print('Gold profile fetch error: $error');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
