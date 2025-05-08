import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/models/gold_price_model.dart';

class GoldPriceProvider extends ChangeNotifier {
  GoldOverviewData? _goldData;
  bool _isLoading = false;
  Timer? _refreshTimer;

  GoldOverviewData? get goldData => _goldData;
  bool get isLoading => _isLoading;

  Future<void> fetchGoldPrice() async {
    const url = 'https://justb2c.grahaksathi.com/api/gold/buy/price';
    const token =
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4OTUxODU0OTQ5IiwiYXV0aCI6IiIsImV4cCI6MTgzMjkzMTA0Nn0.80_jGqb6Mp4Pxb55yd841JBlQHNiICx8js3ytBprjwRpP8ylIeuGeBj4SnjwwOSjEzYVDUNrUze-3rVKYc3_Kw';

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final overview = GoldOverviewResponse.fromJson(data);
        _goldData = overview.data;
      } else {
        throw Exception('Failed to load gold price');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      fetchGoldPrice();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
