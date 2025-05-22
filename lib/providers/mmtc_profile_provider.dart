import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/config/secure_storage_service.dart';

class CreateProfileProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? profileResponse;

  Future<void> createProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final url = Uri.parse(UrlConstants.mmtc_profile);
    final token = await SecureStorageService.getToken();

    if (token == null) {
      error = 'Token not found. Please login first.';
      isLoading = false;
      notifyListeners();
      return;
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: '', // empty request body
      );

      print('Create Profile Response status: ${response.statusCode}');
      print('Create Profile Response body: ${response.body}');

      if (response.statusCode == 200) {
        profileResponse = json.decode(response.body);
        print('Profile success: ${profileResponse?['success']}');
        print('Profile message: ${profileResponse?['message']}');
      } else {
        error = 'Failed with status: ${response.statusCode}';
        print(error);
      }
    } catch (e) {
      error = 'Exception: $e';
      print(error);
    }

    isLoading = false;
    notifyListeners();
  }
}
