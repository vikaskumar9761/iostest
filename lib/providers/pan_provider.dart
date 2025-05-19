import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/models/pan_moder.dart';

class PanVerificationProvider with ChangeNotifier {
  PanInfoResponse? panInfo;
  bool isLoading = false;
  String? error;

  Future<void> verifyPan({required String name, required String pan}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final url = Uri.parse(UrlConstants.panVerify);
    final token = await SecureStorageService.getToken();

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'name': name,
      'pan': pan,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('PAN verify response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        panInfo = PanInfoResponse.fromJson(jsonResponse);
      } else {
        error = 'Failed: ${response.statusCode}';
      }
    } catch (e) {
      error = 'Error: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
