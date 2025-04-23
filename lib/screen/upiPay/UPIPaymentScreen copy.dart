// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:iostest/models/auth/payment_trigger_resp.dart';
// import 'package:upi_india/upi_india.dart'; // Using upi_india package for UPI integration

// class UPIPaymentScreen extends StatefulWidget {
//   final PaymentTriggerResp paymentData;
//   final String transactionId;

//   const UPIPaymentScreen({
//     Key? key,
//     required this.paymentData,
//     required this.transactionId,
//   }) : super(key: key);

//   @override
//   _UPIPaymentScreenState createState() => _UPIPaymentScreenState();
// }

// class _UPIPaymentScreenState extends State<UPIPaymentScreen> {
//   final UpiIndia _upiIndia = UpiIndia();
//   List<UpiApp>? _upiApps;
//   Timer? _statusCheckTimer;
//   bool _isStatusChecking = false;
//   int _statusCheckAttempts = 0;
//   final int _maxStatusCheckAttempts = 24; // 4 minutes with 10-second intervals

//   @override
//   void initState() {
//     super.initState();
//     _getUpiApps();
//   }

//   @override
//   void dispose() {
//     _statusCheckTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> _getUpiApps() async {
//     try {
//       _upiApps = await _upiIndia.getAllUpiApps();
//       setState(() {});
//     } catch (e) {
//       print('Error getting UPI apps: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading UPI apps: $e')),
//       );
//     }
//   }

//   Future<void> _initiatePayment(UpiApp app) async {
//     try {
//       // Extract UPI data from paymentData based on the selected app
//       String upiUrl;

//       switch (app.name.toLowerCase()) {
//         case 'google pay':
//           upiUrl = widget.paymentData.gpay!;
//           break;
//         case 'phonepe':
//           upiUrl = widget.paymentData.phonepe!;
//           break;
//         case 'paytm':
//           upiUrl = widget.paymentData.paytm!;
//           break;
//         default:
//           // Use generic Android UPI URL for other apps
//           upiUrl = widget.paymentData.androidUpi!;
//       }

//       // Extract UPI parameters from the URL
//       Uri uri = Uri.parse(upiUrl.replaceFirst(RegExp(r'^.*?://'), 'https://'));
//       Map<String, String> queryParams = uri.queryParameters;

//       final UpiResponse response = await _upiIndia.startTransaction(
//         app: app,
//         receiverUpiId: queryParams['pa']!,
//         receiverName: queryParams['pn']!.replaceAll('+', ' '),
//         transactionRefId: queryParams['tr']!,
//         transactionNote: 'Payment',
//         amount: double.parse(queryParams['am']!),
//       );

//       // Once payment is initiated, start checking the status
//       if (response.status == UpiPaymentStatus.SUBMITTED) {
//         _startStatusCheck();
//       } else {
//         // Handle other response statuses
//         _handleUpiResponse(response);
//       }
//     } catch (e) {
//       print('Error initiating payment: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error initiating payment: $e')),
//       );
//     }
//   }

//   void _handleUpiResponse(UpiResponse response) {
//     switch (response.status) {
//       case UpiPaymentStatus.SUCCESS:
//         // Navigate to success page
//         _navigateToTransactionSummary(true, "Payment successful");
//         break;
//       case UpiPaymentStatus.FAILURE:
//         // Navigate to failure page
//         _navigateToTransactionSummary(false, "Payment failed");
//         break;
//       case UpiPaymentStatus.SUBMITTED:
//         // Payment is in process, start checking status
//         _startStatusCheck();
//         break;
//       default:
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Transaction ${response.status}')),
//         );
//     }
//   }

//   void _startStatusCheck() {
//     setState(() {
//       _isStatusChecking = true;
//       _statusCheckAttempts = 0;
//     });

//     // Cancel any existing timer
//     _statusCheckTimer?.cancel();

//     // Check immediately first
//     _checkTransactionStatus();

//     // Then set up periodic checks
//     _statusCheckTimer = Timer.periodic(Duration(seconds: 10), (timer) {
//       _statusCheckAttempts++;

//       if (_statusCheckAttempts >= _maxStatusCheckAttempts) {
//         timer.cancel();
//         _navigateToTransactionSummary(false, "Transaction timed out");
//         return;
//       }

//       _checkTransactionStatus();
//     });
//   }

//   Future<void> _checkTransactionStatus() async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://justb2c.grahaksathi.com/api/recharge/payment/zaakpay/up/status'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'orderId': widget.transactionId}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['success'] == true) {
//           final txnStatus = data['data']['txnStatus'];

//           if (txnStatus == 3) {
//             // Transaction successful
//             _statusCheckTimer?.cancel();
//             _navigateToTransactionSummary(true, "Payment successful");
//           } else if (txnStatus == 1) {
//             // Transaction failed/timed out
//             _statusCheckTimer?.cancel();
//             _navigateToTransactionSummary(false, "Transaction failed or timed out");
//           }
//           // If txnStatus is 2, it's still processing, continue checking
//         }
//       }
//     } catch (e) {
//       print('Error checking transaction status: $e');
//     }
//   }

//   void _navigateToTransactionSummary(bool isSuccessful, String message) {
//     setState(() {
//       _isStatusChecking = false;
//     });

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TransactionSummaryScreen(
//           isSuccessful: isSuccessful,
//           message: message,
//           amount: widget.paymentData.amount!!,
//           transactionId: widget.transactionId,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Payment Method'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: _isStatusChecking
//               ? null  // Disable back button while checking status
//               : () => Navigator.pop(context),
//         ),
//       ),
//       body: _isStatusChecking
//           ? _buildStatusCheckingUI()
//           : _buildUpiAppsList(),
//     );
//   }

//   Widget _buildStatusCheckingUI() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 20),
//           Text(
//             'Verifying Payment Status...',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Please wait while we confirm your payment.',
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Do not close this screen.',
//             style: TextStyle(color: Colors.red),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUpiAppsList() {
//     if (_upiApps == null) {
//       return Center(child: CircularProgressIndicator());
//     }

//     if (_upiApps!.isEmpty) {
//       return Center(
//         child: Text(
//           'No UPI apps found on device',
//           style: TextStyle(fontSize: 18),
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Amount: ₹${widget.paymentData.amount}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text('Transaction ID: ${widget.transactionId}'),
//               SizedBox(height: 20),
//               Text(
//                 'Select a payment app:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: GridView.count(
//             crossAxisCount: 3,
//             padding: EdgeInsets.all(16),
//             childAspectRatio: 0.9,
//             children: _upiApps!.map((app) => _buildUpiAppItem(app)).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildUpiAppItem(UpiApp app) {
//     return InkWell(
//       onTap: () => _initiatePayment(app),
//       child: Card(
//         elevation: 2,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.memory(
//               app.icon,
//               height: 50,
//               width: 50,
//             ),
//             SizedBox(height: 12),
//             Text(
//               app.name,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Transaction Summary Screen
// class TransactionSummaryScreen extends StatelessWidget {
//   final bool isSuccessful;
//   final String message;
//   final String amount;
//   final String transactionId;

//   const TransactionSummaryScreen({
//     Key? key,
//     required this.isSuccessful,
//     required this.message,
//     required this.amount,
//     required this.transactionId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transaction Summary'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 isSuccessful ? Icons.check_circle : Icons.error,
//                 color: isSuccessful ? Colors.green : Colors.red,
//                 size: 80,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 isSuccessful ? 'Payment Successful' : 'Payment Failed',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 30),
//               _buildInfoRow('Amount', '₹$amount'),
//               _buildInfoRow('Transaction ID', transactionId),
//               _buildInfoRow('Date & Time', _getCurrentDateTime()),
//               SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: () {
//                   // Navigate back to home or wherever appropriate
//                   Navigator.of(context).popUntil((route) => route.isFirst);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                   child: Text('Done', style: TextStyle(fontSize: 16)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getCurrentDateTime() {
//     final now = DateTime.now();
//     return '${now.day}/${now.month}/${now.year}, ${_formatTimeOfDay(now)}';
//   }

//   String _formatTimeOfDay(DateTime dateTime) {
//     final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
//     final hourString = hour == 0 ? '12' : hour.toString();
//     final minuteString = dateTime.minute.toString().padLeft(2, '0');
//     final period = dateTime.hour >= 12 ? 'PM' : 'AM';
//     return '$hourString:$minuteString $period';
//   }
// }