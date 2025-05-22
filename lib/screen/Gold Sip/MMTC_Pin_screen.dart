import 'package:flutter/material.dart';
import 'package:iostest/providers/mmtc_profile_provider.dart';
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

  // ✅ Reusable dialog method
  void showResultDialog({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).pop(); // Close dialog
                if (isSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              BuyGoldScreen(goldPrice: widget.goldPrice),
                    ),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinProvider = Provider.of<PinCodeProvider>(context);
    final panProvider = Provider.of<PanVerificationProvider>(context);

    final isPinSuccess = pinProvider.pinCodeResponse?.success == true;
    final isPanSuccess = panProvider.panInfo?.success == true;

    isPanFieldEnabled = isPinSuccess;
    final bool canProceed = isPinSuccess && isPanSuccess;

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
            _buildPinField(pinProvider),
            const SizedBox(height: 16),
            _buildPanField(panProvider, isPanSuccess),
          ],
        ),
      ),
    );
  }

  Widget _buildPinField(PinCodeProvider pinProvider) {
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
                  pinProvider.pinCodeResponse == null
                      ? Colors.black
                      : (pinProvider.pinCodeResponse!.data?.serviceable == true
                          ? Colors.green
                          : Colors.red),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              final pin = _pinController.text.trim();

              if (pin.length == 6 && int.tryParse(pin) != null) {
                await pinProvider.checkPincodeServiceable(pin);

                final response = pinProvider.pinCodeResponse;

                if (response == null) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Failed to fetch data. Please try again.',
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  return;
                }

                final bool isServiceable = response.data?.serviceable == true;

                if (mounted) {
                  setState(() {
                    isPanFieldEnabled = isServiceable;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isServiceable
                            ? "Serviceable in ${response.data?.city}, ${response.data?.state}"
                            : (response.message ??
                                "Service not available for this PIN"),
                      ),
                      backgroundColor:
                          isServiceable ? Colors.green : Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid 6-digit PIN code.'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
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
                    if (mounted) setState(() {});
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
                    ? () async {
                      final createProfileProvider =
                          Provider.of<CreateProfileProvider>(
                            context,
                            listen: false,
                          );

                      await createProfileProvider.createProfile();

                      if (createProfileProvider.error != null) {
                        showResultDialog(
                          title: "Error",
                          message: createProfileProvider.error!,
                          isSuccess: false,
                        );
                      } else {
                        showResultDialog(
                          title: "Success",
                          message:
                              "${createProfileProvider.profileResponse?['message']} Profile created successfully.",
                          isSuccess: true,
                        );
                      }
                    }
                    : null,
            child: const Text("PROCEED"),
          ),
        ),
      ],
    );
  }
}
