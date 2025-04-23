import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iostest/models/auth/payment_trigger_resp.dart';
import 'package:iostest/providers/payment_status_notifier.dart';
import 'package:provider/provider.dart';


import 'TransactionSummaryScreen.dart';

class UPIPaymentScreen extends StatefulWidget {
  final PaymentTriggerResp paymentData;
  final String transactionId;

  const UPIPaymentScreen({
    super.key,
    required this.paymentData,
    required this.transactionId,
  });

  @override
  _UPIPaymentScreenState createState() => _UPIPaymentScreenState();
}

class _UPIPaymentScreenState extends State<UPIPaymentScreen> {

  // Timer? _statusCheckTimer;
  // Timer? _timeoutTimer;
  bool _isStatusChecking = false;
  // int _remainingSeconds = 240; // 4 minutes
  // static const Duration checkInterval = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    _getUpiApps();
    //_startStatusCheck();
  }

  void _startStatusCheck() {
    setState(() => _isStatusChecking = true);
    
    final statusNotifier = Provider.of<PaymentStatusNotifier>(context, listen: false);
    statusNotifier.startStatusCheck(
      widget.transactionId,
      (isSuccessful, message) {
        _navigateToTransactionSummary(isSuccessful, message);
      },
    );
  }


  @override
  void dispose() {
    // _statusCheckTimer?.cancel();
    // _timeoutTimer?.cancel();
    super.dispose();
  }

  // void _startTimeoutTimer() {
  //   _timeoutTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_remainingSeconds > 0) {
  //         _remainingSeconds--;
  //       } else {
  //         _timeoutTimer?.cancel();
  //         _navigateToTransactionSummary(false, 'Transaction timed out');
  //       }
  //     });
  //   });
  // }

   String _formatTimeRemaining(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _getUpiApps() async {
    try {

    } catch (e) {
      print('Error getting UPI apps: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading UPI apps: $e')),
      );
    }
  }







  void _navigateToTransactionSummary(bool isSuccessful, String message) {
    // _timeoutTimer?.cancel();
    // _statusCheckTimer?.cancel();
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionSummaryScreen(
          isSuccessful: isSuccessful,
          message: message,
          amount: widget.paymentData.amount!,
          transactionId: widget.transactionId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        final statusNotifier = Provider.of<PaymentStatusNotifier>(context);

    return WillPopScope(
      onWillPop: () async {
        if (_isStatusChecking) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please wait while we verify your payment')),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Complete Payment'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _isStatusChecking ? null : () => Navigator.pop(context),
          ),
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusNotifier.remainingSeconds < 60 ? Colors.red[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _formatTimeRemaining(statusNotifier.remainingSeconds),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  statusNotifier.remainingSeconds < 60 ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            _isStatusChecking ? _buildStatusCheckingUI() : _buildUpiAppsList(),
            if (_isStatusChecking)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              value:  statusNotifier.remainingSeconds / 240,
                              backgroundColor: Colors.grey[300],
                              color: Colors.white,
                              strokeWidth: 8,
                            ),
                          ),
                          Text(
                            _formatTimeRemaining(statusNotifier.remainingSeconds),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Verifying Payment Status...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Please do not close this screen\nwhile we verify your payment',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCheckingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'Verifying Payment Status...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Please wait while we confirm your payment.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Do not close this screen.',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildUpiAppsList() {

    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount: ₹${widget.paymentData.amount}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Transaction ID: ${widget.transactionId}'),
              SizedBox(height: 20),
              Text(
                'Select a payment app:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

      ],
    );
  }



  
  // ... Rest of your existing UI methods (_buildUpiAppsList, _buildUpiAppItem) ...
}