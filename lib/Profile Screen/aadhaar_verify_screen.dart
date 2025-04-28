import 'package:flutter/material.dart';

class AadhaarVerifyScreen extends StatefulWidget {
  const AadhaarVerifyScreen({super.key});

  @override
  State<AadhaarVerifyScreen> createState() => _AadhaarVerifyScreenState();
}

class _AadhaarVerifyScreenState extends State<AadhaarVerifyScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  /// Simulate Aadhaar verification process
  Future<void> _verifyAadhaar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a delay for verification
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aadhaar verified successfully!')),
      );

      // Navigate back or to another screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set AppBar background to white
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Black icon for contrast
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Aadhaar EKYC',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text for contrast
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please Verify Aadhaar As Per KYC Guidelines',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54, // Slightly lighter black for secondary text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Icon(
                Icons.verified_user,
                color: Colors.blue, // Blue icon for better visibility
                size: 100,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _aadhaarController,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter Aadhaar Number',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200], // Light grey background for the input field
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Aadhaar number';
                    }
                    if (value.length != 12) {
                      return 'Aadhaar number must be 12 digits';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyAadhaar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Black button for contrast
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Note: Dear Customer, as per KYC Guidelines Aadhaar KYC is Mandatory. '
                'We ask Aadhaar KYC as it is required to use our services. '
                'We store the last 4 digits of Aadhaar number.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54, // Slightly lighter black for secondary text
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}