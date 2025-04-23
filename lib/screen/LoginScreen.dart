import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iostest/config/deviceInfo.dart';
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/screen/OTPScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iostest/models/login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _termsAccepted = false;

  Future<void> _login() async {
    if (_phoneController.text.length != 10) {
      setState(() => _error = 'Please enter a valid 10-digit mobile number');
      return;
    }

    if (!_termsAccepted) {
      setState(() => _error = 'Please accept terms and conditions');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final request = LoginRequest(
        login: _phoneController.text,
        phone: _phoneController.text,
        deviceimei: DeviceInfo.getdeviceInfo().toString(),
        devicetoken: DeviceInfo.getdeviceInfo().toString(),
        
      );
     final url = '${UrlConstants.baseUrl}/login/v3/otp';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      final loginResponse = LoginResponse.fromJson(json.decode(response.body));

      if (loginResponse.success && loginResponse.code == '200') {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                phoneNumber: _phoneController.text,
               
              ),
            ),
          );
        }
      } else {
        setState(() => _error = loginResponse.message);
      }
    } catch (e) {
      setState(() => _error = 'Failed to send OTP. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top section with black background
            Container(
              width: double.infinity,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add safe area padding at the top
                    SizedBox(height: MediaQuery.of(context).padding.top + 40),
                    
                    // Welcome text
                    Text(
                      'Welcome back!',
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign In To Your Account',
                      style: GoogleFonts.urbanist(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // App logo - simplified to match screenshot more closely
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              const Positioned(
                                right: 25,
                                child: Text(
                                  '₹',
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            
            // Bottom section with white background
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Phone number input with black border
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Country code
                          Container(
                            width: 60,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                right: BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                            child: Text(
                              '+91',
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          
                          // Phone number field
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: _phoneController,
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Mobile Number',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Urbanist',
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Proceed button (black with white text)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Proceed',
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
                      ),
                    ),
                    
                       if (_error != null)
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          _error!,
          style: TextStyle(color: Colors.red[700], fontSize: 12),
        ),
      ),
                    const SizedBox(height: 24),
                    
                    // Terms and conditions
                    Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    GestureDetector(
      onTap: () {
        setState(() {
          _termsAccepted = !_termsAccepted; // Toggle the value
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: _termsAccepted ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        child: _termsAccepted
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : null,
      ),
    ),
    const SizedBox(width: 8),
    Expanded(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.urbanist(
            color: Colors.grey,
            fontSize: 14,
          ),
          children: [
            const TextSpan(text: 'By Clicking On Login Button, you agree to\n'),
            TextSpan(
              text: 'Terms Conditions',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const TextSpan(text: ' Of JustPe Payments'),
          ],
        ),
      ),
    ),
  ],
),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // Add a white container to ensure the space is white
            Container(
              color: Colors.white,
              height: 100, // Ensure the space is white
               // Adjust the height as needed
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}