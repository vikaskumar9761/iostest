import 'package:flutter/material.dart';
import 'package:iostest/apiservice/api_base_helper.dart';
import 'package:iostest/config/url_constants.dart';
import 'dart:convert';

import 'package:iostest/models/auth/payment_trigger_resp.dart';

class PaymentNotifier extends ChangeNotifier {
  final ApiBaseHelper _apiHelper = ApiBaseHelper();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<PaymentTriggerResp?> initiatePayment({
    required String amount,
    required String category,
    required String consumerNumber,
    required String operatorId,
    required List<String> paymentMethods,
    required Map<String, dynamic> adParams,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      // Determine txnType based on selected payment methods
      String txnType = "BOTH";
      if (paymentMethods.length == 1) {
        if (paymentMethods.contains("WALLET")) {
          txnType = "WALLET";
        } else if (paymentMethods.contains("UPI")) {
          txnType = "UPI";
        }
      }

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "adParams": adParams,
        "amt": amount,
        "category": category,
        "cir": "",
        "cn": consumerNumber,
        "op": operatorId,
        "txnType": txnType
      };

      // Convert body to JSON string
      final String jsonBody = json.encode(requestBody);

      // Make API call using ApiBaseHelper
      final response = await _apiHelper.postrequest(
        '${UrlConstants.baseUrl}/recharge/validate/mobile/v3/temp',
        jsonBody,
      );
print(response);

      _isLoading = false;

      if (response['success'] == true) {
        _isSuccess = true;
        notifyListeners();
        final payResp = PaymentTriggerResp.fromJson(response['data']);

        return payResp;
      } else {
        _errorMessage = response['message'] ?? 'Payment initiation failed';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }
}

