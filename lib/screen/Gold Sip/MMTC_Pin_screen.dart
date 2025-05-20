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

  bool isPanFieldEnabled = false;

  @override
  Widget build(BuildContext context) {
    final pinProvider = Provider.of<PinCodeProvider>(context);
    final panProvider = Provider.of<PanVerificationProvider>(context);

    final isPinSuccess = pinProvider.pinCodeResponse?.success == true;
    final isPanSuccess = panProvider.panInfo?.success == true;

    // Enable PAN field only after successful PIN
    isPanFieldEnabled = isPinSuccess;
    print("ispinsuccess${isPanSuccess}");

    final bool canProceed = isPinSuccess && isPanSuccess;

    print("canproceed${canProceed}");

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
              _buildCard(context, pinProvider, panProvider),
              const SizedBox(height: 32),
              _buildActionButtons(context, canProceed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    PinCodeProvider pinProvider,
    PanVerificationProvider panProvider,
  ) {
    final isPinSuccess = pinProvider.pinCodeResponse?.success == true;
    final isPanSuccess = panProvider.panInfo?.success == true;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter PINCODE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildPinField(pinProvider, isPinSuccess),
            const SizedBox(height: 16),
            _buildPanField(panProvider, isPanSuccess),
          ],
        ),
      ),
    );
  }

  Widget _buildPinField(PinCodeProvider pinProvider, bool isPinSuccess) {
    final pinResponse = pinProvider.pinCodeResponse;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _pinController,
            decoration: const InputDecoration(
              hintText: "Enter PINCODE",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  pinResponse == null
                      ? Colors.black
                      : (isPinSuccess ? Colors.green : Colors.pink),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              final pin = _pinController.text.trim();
              if (pin.length == 6 && int.tryParse(pin) != null) {
                await pinProvider.checkPincodeServiceable(pin);
                if (mounted) {
                  setState(() {
                    isPanFieldEnabled =
                        pinProvider.pinCodeResponse?.success == true;
                  });
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid 6-digit PIN code.'),
                  ),
                );
              }
            },
            child: const Text("CHECK"),
          ),
        ),
      ],
    );
  }

  Widget _buildPanField(
    PanVerificationProvider panProvider,
    bool isPanSuccess,
  ) {
    final panResponse = panProvider.panInfo;

    return Opacity(
      opacity: isPanFieldEnabled ? 1 : 0.5,
      child: IgnorePointer(
        ignoring: !isPanFieldEnabled,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _panController,
                decoration: const InputDecoration(
                  hintText: "Enter PAN",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      panResponse == null
                          ? Colors.black
                          : (isPanSuccess ? Colors.green : Colors.pink),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () async {
                  final pan = _panController.text.trim().toUpperCase();
                  if (pan.length == 10) {
                    await panProvider.verifyPan(
                      name: 'PUJA KUMARI', // Replace with dynamic name
                      pan: pan,
                    );
                    if (mounted) {
                      setState(() {});
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter valid PAN')),
                    );
                  }
                },
                child: const Text("VERIFY"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool canProceed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("CANCEL", style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: canProceed ? Colors.black : Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed:
                canProceed
                    ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  BuyGoldScreen(goldPrice: widget.goldPrice),
                        ),
                      );
                    }
                    : null,
            child: const Text("PROCEED"),
          ),
        ),
      ],
    );
  }
}
