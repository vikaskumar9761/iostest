import 'package:flutter/material.dart';
import 'package:iostest/providers/otp_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _otp = '';

  void _handleVerification() async {
    if (_otp.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    final otpNotifier = Provider.of<OtpNotifier>(context, listen: false);
    final success = await otpNotifier.verifyOtp(widget.phoneNumber, _otp);

    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(otpNotifier.error ?? 'Verification failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<OtpNotifier>(
        builder: (context, notifier, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Verify OTP',
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the 6-digit code sent to',
                      style: GoogleFonts.urbanist(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.phoneNumber,
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    /// OTP Input Field using PinCodeTextField
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      animationType: AnimationType.fade,
                      textStyle: const TextStyle(color: Colors.white),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 45,
                        inactiveColor: Colors.white38,
                        activeColor: Colors.white,
                        selectedColor: Colors.amber,
                        activeFillColor: Colors.white10,
                        inactiveFillColor: Colors.white10,
                        selectedFillColor: Colors.white10,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _otp = value;
                        });
                      },
                      onCompleted: (value) {
                        setState(() {
                          _otp = value;
                        });
                        _handleVerification();
                      },
                    ),

                    const SizedBox(height: 40),

                    /// Verify Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            notifier.isLoading ? null : _handleVerification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            notifier.isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                  'Verify',
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Loading overlay
              if (notifier.isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
