import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iostest/apiservice/api_base_helper.dart';
import 'package:iostest/config/url_constants.dart';

class BillNotifier extends ChangeNotifier {
  final ApiBaseHelper _apiHelper = ApiBaseHelper();
  bool isLoading = false;
  String? error;
   String? selectedCircleName;


  Future<Map<String, dynamic>?> fetchBill({
    required String category,
    required String operatorId,
    required String operatorType,
    required Map<String, dynamic> inputValues,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> requestBody = {
        'adParams': {},
        'amount': inputValues['amt'] ?? '0',
        'category': category,
        'cir': '',
        'cn': inputValues['cn'],
        'op': operatorId,
      };

      // Encode the body to JSON string
      final jsonBody = json.encode(requestBody);

      final response = await _apiHelper.postrequest(
        '${UrlConstants.baseUrl}/recharge/v3/bill',
        jsonBody, // Send encoded JSON string
      );

      isLoading = false;
      notifyListeners();

      if (response['success'] == true) {
        return response['data'][0];
      } else {
        error = response['message'] ?? 'Failed to fetch bill';
        return null;
      }
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}