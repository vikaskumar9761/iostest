import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iostest/apiservice/api_base_helper.dart';
import 'package:iostest/config/url_constants.dart';

class PaymentStatusNotifier extends ChangeNotifier {
  final ApiBaseHelper _apiHelper = ApiBaseHelper();
  bool _isLoading = false;
  String? _error;
  final bool _isSuccess = false;
  int _remainingSeconds = 240;
  Timer? _timeoutTimer;
  Timer? _statusCheckTimer;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSuccess => _isSuccess;
  int get remainingSeconds => _remainingSeconds;
  Map<String, dynamic>? _transactionData;
  Map<String, dynamic>? get transactionData => _transactionData;

  void startStatusCheck(String transactionId, Function(bool, String) onComplete) {
    _isLoading = true;
    _error = null;
    _remainingSeconds = 240;
    notifyListeners();

    _startTimeoutTimer(onComplete);
    _checkStatus(transactionId, onComplete);
  }

  void _startTimeoutTimer(Function(bool, String) onComplete) {
    _timeoutTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timeoutTimer?.cancel();
        _statusCheckTimer?.cancel();
        onComplete(false, 'Transaction timed out');
      }
    });
  }

  void _checkStatus(String transactionId, Function(bool, String) onComplete) {
    _checkTransactionStatus(transactionId).then((status) {
      if (status == 3) { // Success
        _timeoutTimer?.cancel();
        _statusCheckTimer?.cancel();
        onComplete(true, 'Payment successful');
      } else if (status == 1) { // Failed
        _timeoutTimer?.cancel();
        _statusCheckTimer?.cancel();
        onComplete(false, 'Payment failed');
      } else { // Processing (status == 2)
        if (_remainingSeconds > 0) {
          _statusCheckTimer = Timer(Duration(seconds: 10), () {
            _checkStatus(transactionId, onComplete);
          });
        }
      }
    });
  }

  Future<int> _checkTransactionStatus(String transactionId) async {
    try {
      final response = await _apiHelper.postrequest(
        '${UrlConstants.baseUrl}/recharge/payment/zaakpay/up/status',
        {'orderId': transactionId},
      );

      if (response['success'] == true) {
         _transactionData = response['data'];
        return response['data']['txnStatus'] as int;
      }
      throw Exception(response['message'] ?? 'Failed to check status');
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 2; // Return processing to continue checking
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _statusCheckTimer?.cancel();
    super.dispose();
  }
}