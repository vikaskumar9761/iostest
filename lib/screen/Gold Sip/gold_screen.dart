import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iostest/providers/GoldPriceProvider.dart';
import 'package:iostest/providers/gold_profile_provider.dart';
import 'package:iostest/providers/gold_rate_provider.dart';
import 'package:iostest/models/gold_rate_model.dart';
import 'package:iostest/screen/Gold%20Sip/buy_gold_screen.dart';
import 'package:provider/provider.dart';

class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key});

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {
  String _selectedTimeRange = "1M"; // Default time range button selected
  List<FlSpot> _chartData = []; // Chart data points
  Map<String, List<GoldRateEntry>> _goldGroupedData = {}; // Grouped gold data
  bool _isLoading = true; // Loading state
    double? _goldPrice; // Current gold price


 Timer? _refreshTimer;
 
 @override
void dispose() {
  _refreshTimer?.cancel();
  print("🛑 Auto-refresh timer cancelled in dispose()");
  super.dispose();
}

@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _fetchGoldProfileData();
    _fetchGroupedData();
    _fetchGoldBuyPrice();

    // // ⏱️ Auto refresh every 2 minutes
    // _refreshTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
    //   print('🔁 Auto-refreshing gold data...');
    //  // _fetchGoldProfileData();
    //  // _fetchGroupedData();
    //   _fetchGoldBuyPrice();
    // });
  });
}


  // Fetch gold profile data
  void _fetchGoldProfileData() async {
    try {
      print('Calling fetchGoldProfile...');
      final provider = Provider.of<GoldProfileProvider>(context, listen: false);
      await provider.fetchGoldProfile();
      print('Gold profile fetched successfully');
    } catch (error) {
      print('Error fetching gold profile: $error');
    }
  }

  // Fetch grouped gold rate data
  void _fetchGroupedData() async {
    try {
      final groupedData = await fetchGoldHistoricalDataGrouped();
      _goldGroupedData = groupedData;
      _loadChartData(); // Prepare chart data
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Prepare chart data based on selected time range
  void _loadChartData() {
    final selectedData = _goldGroupedData[_selectedTimeRange];
    if (selectedData != null && selectedData.isNotEmpty) {
      final reversedData = selectedData.reversed.toList(); // Latest data last
      _chartData = reversedData.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.rate.toDouble()); // Index vs rate
      }).toList();
    } else {
      _chartData = [];
    }
  }

    // Fetch current gold buy price
  void _fetchGoldBuyPrice() async {
    try {
      final goldPriceProvider = Provider.of<GoldPriceProvider>(context, listen: false);
      await goldPriceProvider.fetchGoldPrice();

      final goldData = goldPriceProvider.goldData;
      if (goldData != null) {
        setState(() {
          _goldPrice = goldData.price.currentPrice; // Set the current gold price
        });
        print("✅ Gold Price fetched successfully:");
        print("👉 Current Price: ₹${goldData.price.currentPrice}");
        print("👉 Price with GST: ₹${goldData.price.priceWithGst}");
        print("👉 Total Gold: ${goldData.totalGold} gms");
        print("👉 Total Invest: ₹${goldData.totalInvest}");
      }
    } catch (e) {
      print("❌ Error fetching gold buy price: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoldProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gold in Locker"),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Locker Info Box
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
                          "MMTC Balance: ${provider.goldProfile?.data.mmtcBal ?? '0.0'} gms",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "SafeGold Balance: ${provider.goldProfile?.data.safegoldBal ?? '0.0'} gms",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Buy Price: ₹${_goldPrice?.toStringAsFixed(2) ?? 'Loading...'} / gm  + 3% GST",
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chart Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: _chartData.isEmpty
                              ? const Center(child: Text("No chart data"))
                              : LineChart(
                                  LineChartData(
                                    gridData: FlGridData(show: false),
                                    titlesData: FlTitlesData(show: false),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: const Border(
                                        bottom: BorderSide(color: Colors.grey),
                                        left: BorderSide(color: Colors.grey),
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
                                          color: Colors.purple.withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Time Range Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: ["1M", "3M", "6M", "1Y"]
                              .map((range) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedTimeRange = range;
                                        _loadChartData();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _selectedTimeRange == range ? Colors.black : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Text(
                                        range,
                                        style: TextStyle(
                                          color: _selectedTimeRange == range ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  // SIP and Buy Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Future implementation: SIP functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text(
                            "START SIP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ElevatedButton(
  onPressed: () {
    if (_goldPrice != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BuyGoldScreen(goldPrice: _goldPrice!), // Pass gold price
        ),
      );
    } else {
      print("Gold price is not available");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gold price is not available")),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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

                  // Sell & History
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.sell, color: Colors.amber),
                          title: const Text("Sell Gold"),
                          subtitle: const Text("Sell Gold, explore SIP & do more!"),
                          onTap: () {
                            // Future: Sell Gold functionality
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.history, color: Colors.grey),
                          title: const Text("Transaction History"),
                          subtitle: const Text("All Gold Buy / Sell History"),
                          onTap: () {
                            // Future: Navigate to history screen
                          },
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
