import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/apiservice/setheader.dart';
import 'package:iostest/models/gold_price_model.dart';

class GoldPriceProvider extends ChangeNotifier {
  GoldOverviewData? _goldData;
  bool _isLoading = false;
  Timer? _refreshTimer;

  GoldOverviewData? get goldData => _goldData;
  bool get isLoading => _isLoading;

  Future<void> fetchGoldPrice() async {
    final url = Uri.parse(UrlConstants.goldBuyPrice);
    final headers = await SetHeaderHttps.setHttpheader();

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final overview = GoldOverviewResponse.fromJson(data);
        _goldData = overview.data;
      } else {
        throw Exception(
          'Failed to load gold price (status: ${response.statusCode})',
        );
      }
    } catch (error) {
      print('❌ Error fetching gold price: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
