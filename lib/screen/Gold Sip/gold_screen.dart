import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iostest/providers/GoldPriceProvider.dart';
import 'package:iostest/providers/gold_profile_provider.dart';
import 'package:iostest/models/gold_rate_model.dart';
import 'package:iostest/providers/gold_rate_provider.dart';
import 'package:iostest/screen/Gold%20Sip/buy_gold_screen.dart';
import 'package:iostest/screen/Profile%20Screen/profile_screen.dart';
import 'package:provider/provider.dart';

class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key});

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {
  String _selectedTimeRange = "1M";
  List<FlSpot> _chartData = [];
  Map<String, List<GoldRateEntry>> _goldGroupedData = {};
  bool _isLoading = true;
  double? _goldPrice;

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchGroupedData();
      _fetchGoldProfileData();
      _fetchGoldBuyPrice();

      // Uncomment below to enable auto-refresh
      _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
        _fetchGoldBuyPrice();
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    print("🛑 Auto-refresh timer cancelled in dispose()");
    super.dispose();
  }

  /// Fetches gold profile details (like balance and onboarding status)
  void _fetchGoldProfileData() async {
    try {
      final provider = Provider.of<GoldProfileProvider>(context, listen: false);
      await provider.fetchGoldProfile();
      print('✅ Gold profile fetched successfully');
    } catch (error) {
      print('❌ Error fetching gold profile: $error');
    }
  }

  /// Fetches historical grouped gold rate data (used for charting)
  void _fetchGroupedData() async {
    try {
      final groupedData = await fetchGoldHistoricalDataGrouped();
      _goldGroupedData = groupedData;
      _loadChartData();
      setState(() => _isLoading = false);
    } catch (error) {
      print('❌ Error fetching chart data: $error');
      setState(() => _isLoading = false);
    }
  }

  /// Converts selected historical gold rate entries into `FlSpot` chart data
  void _loadChartData() {
    final selectedData = _goldGroupedData[_selectedTimeRange];
    if (selectedData != null && selectedData.isNotEmpty) {
      final reversedData = selectedData.reversed.toList();
      _chartData =
          reversedData.asMap().entries.map((entry) {
            return FlSpot(entry.key.toDouble(), entry.value.rate.toDouble());
          }).toList();
    } else {
      _chartData = [];
    }
  }

  /// Fetches the current gold price (including GST)
  void _fetchGoldBuyPrice() async {
    try {
      final provider = Provider.of<GoldPriceProvider>(context, listen: false);
      await provider.fetchGoldPrice();
      final goldData = provider.goldData;
      if (goldData != null) {
        setState(() => _goldPrice = goldData.price.currentPrice);
        print("✅ Gold price fetched: ₹${goldData.price.currentPrice}");
      }
    } catch (e) {
      print("❌ Error fetching gold buy price: $e");
    }
  }

 

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<GoldProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Gold in Locker")),
      body:
          profileProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔐 Locker Info Card
                    Container(
                      color: Colors.black,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Gold in Locker",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "MMTC Balance: ${profileProvider.goldProfile?.data.mmtcBal ?? '0.0'} gms",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "SafeGold Balance: ${profileProvider.goldProfile?.data.safegoldBal ?? '0.0'} gms",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Buy Price: ₹${_goldPrice?.toStringAsFixed(2) ?? 'Loading...'} / gm + 3% GST",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Live",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📈 Chart Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child:
                                _isLoading
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : _chartData.isEmpty
                                    ? const Center(child: Text("No chart data"))
                                    : LineChart(
                                      LineChartData(
                                        gridData: FlGridData(show: false),
                                        titlesData: FlTitlesData(show: false),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: const Border(
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                            ),
                                            left: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: _chartData,
                                            isCurved: true,
                                            color: Colors.purple,
                                            barWidth: 3,
                                            isStrokeCapRound: true,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              color: Colors.purple.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                          ),

                          const SizedBox(height: 16),

                          // ⏱️ Time Range Filter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:
                                ["1M", "3M", "6M", "1Y"].map((range) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedTimeRange = range;
                                        _loadChartData();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _selectedTimeRange == range
                                                ? Colors.black
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Text(
                                        range,
                                        style: TextStyle(
                                          color:
                                              _selectedTimeRange == range
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),

                    // 🪙 SIP & Buy Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "START SIP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_goldPrice != null) {
                                if (profileProvider
                                        .goldProfile
                                        ?.data
                                        .safegold ==
                                    true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => BuyGoldScreen(
                                            goldPrice: _goldPrice!,
                                          ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Gold price is not available",
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "BUY ONE TIME",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🧾 Sell / History
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.sell,
                              color: Colors.amber,
                            ),
                            title: const Text("Sell Gold"),
                            subtitle: const Text(
                              "Sell Gold, explore SIP & do more!",
                            ),
                            onTap: () {},
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.history,
                              color: Colors.grey,
                            ),
                            title: const Text("Transaction History"),
                            subtitle: const Text("All Gold Buy / Sell History"),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
