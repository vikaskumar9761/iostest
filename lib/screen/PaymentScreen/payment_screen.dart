
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
    final String selectedCircleName;
  final String selectedCircleId;
  final String number;
  final String operatorName;
  final String operatorId;
  final String category;
  final String operatorType;
  final Map<String, dynamic> billerObject;
  final String planName;
  final double amount;
  final String validity;

  const PaymentScreen({
    super.key,
        required this.operatorType,
    required this.selectedCircleName,
    required this.selectedCircleId,
    required this.number,
    required this.operatorName,
    required this.operatorId,
    required this.category,
    required this.billerObject,
    required this.planName,
    required this.amount,
    required this.validity,
  });
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
           appBar: AppBar(
        backgroundColor: Color(0xFFe1e8f0),//e1e8f0
        title: Text(
          number,
          style: TextStyle(
            fontWeight: FontWeight.bold, // Optional: bold title
          ),
        ),
        centerTitle: true, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/images/bharat_connect.png', // ✅ Path to your image
              height: 45,
              width: 45,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
        
            color: const Color(0xFFe1e8f0),//e1e8f0
            child: Column(
              
              children: [
                 Text(
                  operatorName,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  decoration: BoxDecoration(
                    
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Bill Amount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        amount.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Validity - ${validity.toString()}',
                  style: const TextStyle(color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                      ),
                ),
                const Divider(color: Colors.black87, thickness: 1),
                 Text(
                  'Plan Name - ${planName.toString()}',
                  style: TextStyle(color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer Convenience Fee',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          
                          )),
                      Text('₹ 0.00',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        amount.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 40,
            color:  Colors.black, //e1e8f0
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              'Payment Options',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (_) {}),
                    const Text(
                      'Use Wallet Balance ₹0.0',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (_) {}),
                    const Text(
                      'Pay By UPI',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Proceed to pay',
                style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}