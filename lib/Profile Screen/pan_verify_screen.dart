import 'package:flutter/material.dart';

class PanVerifyScreen extends StatefulWidget {
  const PanVerifyScreen({super.key});

  @override
  State<PanVerifyScreen> createState() => _PanVerifyScreenState();
}

class _PanVerifyScreenState extends State<PanVerifyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  /// Simulate PAN verification process
  Future<void> _verifyPan() async {
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
        const SnackBar(content: Text('PAN verified successfully!')),
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
                'Enter Your Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text for contrast
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please Verify Your Name from PAN',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54, // Slightly lighter black for secondary text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Image.asset(
              //   'assets/images/pan_verification.png', // Replace with your asset path
              //   height: 150,
              // ),

              Icon(
                Icons.verified_user_sharp,
                size: 100,
                color: Colors.black, // Black icon for contrast
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Input Field
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Enter Your Name',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200], // Light grey background for the input field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // PAN Input Field
                    TextFormField(
                      controller: _panController,
                      keyboardType: TextInputType.text,
                      maxLength: 10,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Enter PAN (Optional)',
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
                        if (value != null && value.isNotEmpty && value.length != 10) {
                          return 'PAN must be 10 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyPan,
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
                'Note: PAN Verification is Required Only for Using Gold and SIP',
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