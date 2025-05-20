import 'package:flutter/material.dart';
import 'package:iostest/providers/gold_profile_provider.dart';
import 'package:iostest/screen/Gold%20Sip/MMTC_Pin_screen.dart';
import 'package:iostest/widgets/buy_gold_widgets.dart';
import 'package:provider/provider.dart';

class BuyGoldScreen extends StatefulWidget {
  final dynamic goldPrice;

  const BuyGoldScreen({super.key, required this.goldPrice});

  @override
  State<BuyGoldScreen> createState() => _BuyGoldScreenState();
}

class _BuyGoldScreenState extends State<BuyGoldScreen> {
  bool _buyInRupees = true;

  // Remove this incorrect provider reference

  final TextEditingController _amountController = TextEditingController(
    text: '10',
  );
  // final double _goldPrice = widget.goldPrice. ?? 0.0; // Assuming goldPrice is a double
  final List<int> _recommendedAmounts = [100, 500, 1500, 5000];
  String _selectedProvider = 'SafeGold';

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {});
    });
  }

  /// Shows onboarding dialog for SafeGold users
  void _showOnboardingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text("MMTC Gold Onboarding"),
            content: const Text(
              "We need to onboard you to proceed with the gold purchase. Would you like to continue?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              BuyGoldScreen(goldPrice: widget.goldPrice),
                    ),
                  ); // Close the dialog
                },
                child: const Text("CANCEL"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // Close the dialog first
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                      builder:
                          (_) => MMTC_PinScreen(goldPrice: widget.goldPrice),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text(
                  "PROCEED",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showProviderDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Provider',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                /// SafeGold Navigate to SafeGold onboarding
                BuyGoldWidgets.buildProviderOption(
                  icon: Icons.monetization_on,
                  title: 'SafeGold',
                  subtitle: 'Buy 24K Gold at your convenience',
                  isSelected: _selectedProvider == 'SafeGold',
                  onTap: () {
                    setState(() => _selectedProvider = 'SafeGold');
                    Navigator.pop(context);
                  },
                ),

                /// MMTC Navigate to MMTC onboarding manage if and else
                const Divider(),
                BuyGoldWidgets.buildProviderOption(
                  icon: Icons.account_balance,
                  title: 'MMTC',
                  subtitle: 'Buy Gold from MMTC PAMP',
                  isSelected: _selectedProvider == 'MMTC',
                  onTap: () {
                    final profileProvider = Provider.of<GoldProfileProvider>(
                      context,
                      listen: false,
                    );
                    print(
                      "MMTC value ${profileProvider.goldProfile?.data.mmtc}",
                    );
                    if (profileProvider.goldProfile?.data.mmtc == true) {
                      Navigator.pop(context);
                      setState(() => _selectedProvider = 'MMTC');
                    } else {
                      _showOnboardingDialog(context);
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<GoldProfileProvider>(context);
    double gramsValue = 0.0;
    double finalAmount = 0.0;
    double priceWithGst = double.parse(
      (widget.goldPrice * 1.03).toStringAsFixed(2),
    ); // GST included

    try {
      double input = double.tryParse(_amountController.text) ?? 0.0;

      if (_buyInRupees) {
        gramsValue = input / priceWithGst;
        gramsValue = double.parse(
          gramsValue.toStringAsFixed(4),
        ); // show 4 decimal grams
        finalAmount = input;
      } else {
        gramsValue = input;

        double rawAmount = gramsValue * priceWithGst;
        String rawStr = rawAmount.toStringAsFixed(3);
        int thirdDecimal = int.tryParse(rawStr.split('.')[1][2]) ?? 0;

        if (thirdDecimal == 0) {
          finalAmount = double.parse(
            rawStr.substring(0, rawStr.length - 1),
          ); // truncate
        } else {
          finalAmount = double.parse(
            rawAmount.toStringAsFixed(2),
          ); // round normally
        }
      }
    } catch (_) {}

    bool isValidInput =
        _buyInRupees
            ? (double.tryParse(_amountController.text) ?? 0.0) >= 10
            : (double.tryParse(_amountController.text) ?? 0.0) >= 0.10;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: _showProviderDialog,
          child: Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              Text(
                _selectedProvider,
                style: const TextStyle(color: Colors.white),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: const Color(0xFFF9F9F9),
                elevation: 5,
                shadowColor: const Color.fromARGB(255, 156, 156, 156),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Buy 24K Gold at your convenience',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Free storage in secure bank-grade lockers',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          BuyGoldWidgets.buildToggleButton(
                            'Buy in rupees',
                            _buyInRupees,
                            () {
                              setState(() => _buyInRupees = true);
                            },
                          ),
                          const SizedBox(width: 16),
                          BuyGoldWidgets.buildToggleButton(
                            'Buy in grams',
                            !_buyInRupees,
                            () {
                              setState(() => _buyInRupees = false);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // ✅ Replace starts here
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          prefixText: _buyInRupees ? '₹ ' : 'gm ',
                          suffixText:
                              _buyInRupees
                                  ? '= ${gramsValue.toStringAsFixed(4)} gm'
                                  : '= ₹${finalAmount.toStringAsFixed(2)}',
                          border: const UnderlineInputBorder(),
                          errorText:
                              !isValidInput
                                  ? _buyInRupees
                                      ? 'Min amount is ₹10'
                                      : 'Min weight is 0.10 gm'
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ✅ Replace ends here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _buyInRupees ? 'Min ₹10' : 'Min 0.01 gm',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Live Price: ₹${widget.goldPrice.toStringAsFixed(2)}/gm + 3% GST',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Recommended',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            _recommendedAmounts
                                .map(
                                  (amount) => BuyGoldWidgets.buildAmountChip(
                                    amount: amount,
                                    buyInRupees: _buyInRupees,
                                    goldPrice: priceWithGst,
                                    controller: _amountController,
                                    onUpdate: () => setState(() {}),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Before using our Services and before buying the Gold, Users are also recommended to read the terms of services and privacy policy of Digital Gold India Private Limited which can be accessed at https://www.safegold.com/terms-and-conditions.',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle payment with finalAmount and gramsValue
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Pay',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
