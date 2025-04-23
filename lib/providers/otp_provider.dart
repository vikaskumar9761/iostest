import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iostest/apiservice/api_base_helper.dart';
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/models/auth/user_model.dart';
import 'package:iostest/config/secure_storage_service.dart';

class OtpNotifier extends ChangeNotifier {
  final ApiBaseHelper _apiHelper = ApiBaseHelper();
  bool isLoading = false;
  String? error;

  Future<bool> verifyOtp(String login, String otp) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      
      final url = '${UrlConstants.verifyOtp}?otp=$otp&login=$login';

      final body = json.encode({
        'otp': otp,
        'login': login,
      });
      
      final response = await _apiHelper.postrequest(url,body);

      if (response['success'] == true && response['code'] == '200') {
        final userData = UserModel.fromJson(response['data']['user']);
        final token = response['data']['token'];
        

         await SecureStorageService.saveAuthData(
          response['data']['token'],
          response['data']['user'],
        );

        
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = response['message'] ?? 'Verification failed';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}