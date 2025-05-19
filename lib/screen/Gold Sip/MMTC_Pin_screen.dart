import 'package:flutter/material.dart';
import 'package:iostest/providers/pan_provider.dart';
import 'package:iostest/providers/pin_code_provider.dart';
import 'package:iostest/screen/Gold%20Sip/buy_gold_screen.dart';
import 'package:provider/provider.dart';

class MMTC_PinScreen extends StatefulWidget {
  final dynamic goldPrice;
  const MMTC_PinScreen({super.key, required this.goldPrice});

  @override
  State<MMTC_PinScreen> createState() => _MMTC_PinScreenState();
}

class _MMTC_PinScreenState extends State<MMTC_PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  void _onCheckPinPressed(BuildContext context) async {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a PINCODE')));
      return;
    }
    final provider = Provider.of<PinCodeProvider>(context, listen: false);
    await provider.checkPincodeServiceable(pin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MMTC Onboarding'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Card with PINCODE and PAN fields
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enter PINCODE
                      // Enter PINCODE
                      const Text(
                        "Enter PINCODE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Consumer<PinCodeProvider>(
                        builder: (context, provider, _) {
                          final response = provider.pinCodeResponse;
                          final isServiceable =
                              response?.data.serviceable == true;

                          final buttonColor =
                              response == null
                                  ? Colors.black
                                  : (isServiceable
                                      ? Colors.green
                                      : Colors.pink);

                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _pinController,
                                  enabled: !isServiceable,
                                  decoration: const InputDecoration(
                                    hintText: "Enter PINCODE",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    final pin = _pinController.text.trim();
                                    if (pin.length == 6 &&
                                        int.tryParse(pin) != null) {
                                      Provider.of<PinCodeProvider>(
                                        context,
                                        listen: false,
                                      ).checkPincodeServiceable(pin);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please enter a valid 6-digit PIN code.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text("CHECK"),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _panController,
                              decoration: const InputDecoration(
                                hintText: "Enter PAN",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                // TODO: Add PAN verify logic
                                Provider.of<PanVerificationProvider>(
                                  context,
                                  listen: false,
                                ).verifyPan(
                                  name: 'PUJA KUMARI',
                                  pan: _panController.text ?? 'AKTPY4340E',
                                );
                              },
                              child: const Text("VERIFY"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Cancel & Proceed buttons outside the card, centered
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  BuyGoldScreen(goldPrice: widget.goldPrice),
                        ),
                      );
                    },
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Add proceed logic
                        if (_pinController.text.isNotEmpty &&
                            _panController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BuyGoldScreen(
                                    goldPrice: widget.goldPrice,
                                  ),
                            ),
                          );
                        }
                      },
                      child: const Text("PROCEED"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
