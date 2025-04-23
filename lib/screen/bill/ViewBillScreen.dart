import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iostest/models/auth/payment_trigger_resp.dart';
import 'package:iostest/providers/PaymentNotifier.dart';
import 'package:iostest/screen/upiPay/UPIPaymentScreen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewBillScreen extends StatefulWidget {
  final String consumerNumber;
  final String operatorName;
  final String operatorId;
  final String category;
  final String number; 
  final Map<String, dynamic> billData;

  const ViewBillScreen({
    super.key,
    required this.number,
    required this.consumerNumber,
    required this.operatorName,
    required this.operatorId,
    required this.category,
    required this.billData,
  });

  @override
  _ViewBillScreenState createState() => _ViewBillScreenState();
}

class _ViewBillScreenState extends State<ViewBillScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<String> _selectedPaymentMethods = [];
  final Map<String, dynamic> _paymentOptions = {
    'WALLET': {'name': 'Use Wallet Balance', 'balance': '₹12.89'},
    'UPI': {'name': 'Pay By UPI', 'balance': null},
  };

  @override
  void initState() {
    super.initState();
    // Initialize the amount controller with the bill amount
    _amountController.text = widget.billData['billAmount'] ?? '0.00';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _togglePaymentMethod(String method) {
    setState(() {
      if (_selectedPaymentMethods.contains(method)) {
        _selectedPaymentMethods.remove(method);
      } else {
        _selectedPaymentMethods.add(method);
      }
    });
  }

  Future<void> _proceedToPayment(BuildContext context) async {

    final amount = double.tryParse(_amountController.text) ?? 0;
  
  if (amount <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter a valid amount')),
    );
    return;
  }

  if (_selectedPaymentMethods.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select a payment method')),
    );
    return;
  }

    if (_selectedPaymentMethods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one payment method')),
      );
      return;
    }

    final paymentNotifier = Provider.of<PaymentNotifier>(context, listen: false);
    
    try {
    var upiData=  await paymentNotifier.initiatePayment(
        amount: _amountController.text,
        category: widget.category,
        consumerNumber: widget.consumerNumber,
        operatorId: widget.operatorId,
        paymentMethods: _selectedPaymentMethods,
        adParams: {},
      );
      
      // If payment initiation is successful, navigate to UPI app
      if (paymentNotifier.isSuccess && upiData != null) {
         Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UPIPaymentScreen(
          paymentData: upiData ?? PaymentTriggerResp(), // Provide a default value or handle null
          transactionId: upiData.transid ?? '', // Provide a default value or handle null
          
        ),
      ),
    );
        // Here you would typically launch the UPI app or handle the next steps
        // For now, we'll just show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment initiated successfully. Redirecting to UPI...')),
        );
      }else{
        // Handle the error case
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(paymentNotifier.errorMessage ?? 'Failed to initiate payment')),
        );
      }
    } catch (e) {
      // Error is already handled in the notifier
    }
  }

  bool _canProceed() {
  final amount = double.tryParse(_amountController.text) ?? 0;
  return amount > 0 && _selectedPaymentMethods.isNotEmpty;
}



  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFECF0F3),
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.consumerNumber,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/images/bharat_connect.png', height: 32),
          ),
        ],
      ),
      body: Consumer<PaymentNotifier>(
        builder: (context, paymentNotifier, child) {
          if (paymentNotifier.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          return Container(
            color: Color(0xFFECF0F3),
            child: Column(
              children: [
                // Bill details section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Operator name
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.operatorName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        // Bill amount input - centered
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _amountController,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      '₹',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                  labelText: 'Bill Amount',
                                  labelStyle: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.red, width: 1),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Consumer name
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.billData['userName'] ?? 'MARUTHI TEMPLE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        // Due date
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Bill Due On ${widget.billData['dueDate'] ?? '2025-03-16'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        
                        // Divider
                        Divider(),
                        
                        // Customer convenience fee
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Customer Convenience Fee',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '₹ 0.00',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Total amount
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹ ${_amountController.text}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Payment options header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          color: Colors.grey.shade800,
                          child: Text(
                            'Payment Options',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        // Payment options
                        Column(
                          children: _paymentOptions.entries.map((entry) {
                            final method = entry.key;
                            final details = entry.value;
                            
                            return InkWell(
                              onTap: () => _togglePaymentMethod(method),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 2),
                                        color: _selectedPaymentMethods.contains(method)
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      child: _selectedPaymentMethods.contains(method)
                                          ? Icon(Icons.check, size: 16, color: Colors.white)
                                          : null,
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        details['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (details['balance'] != null)
                                      Text(
                                        details['balance'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Error message
                if (paymentNotifier.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      paymentNotifier.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                
                // Proceed to pay button
                Container(
  width: double.infinity,
  padding: EdgeInsets.all(16),
  child: ElevatedButton(
    onPressed: _canProceed() 
      ? () => _proceedToPayment(context)
      : null,  // Button will be disabled if conditions aren't met
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      disabledBackgroundColor: Colors.grey,
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    child: Text(
      'Proceed to pay',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ),
),
              ],
            ),
          );
        },
      ),
    );
  }
}