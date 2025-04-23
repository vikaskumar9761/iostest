import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iostest/screen/main/HomePage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomePage(), // Pass the phone number
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Proceed',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Terms and conditions
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.black,
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
}