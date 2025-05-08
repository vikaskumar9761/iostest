class GoldOverviewResponse {
  final bool success;
  final String code;
  final GoldOverviewData data;
  final String message;

  GoldOverviewResponse({
    required this.success,
    required this.code,
    required this.data,
    required this.message,
  });

  factory GoldOverviewResponse.fromJson(Map<String, dynamic> json) {
    return GoldOverviewResponse(
      success: json['success'],
      code: json['code'],
      data: GoldOverviewData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class GoldOverviewData {
  final String totalValue;
  final String percentChange;
  final String totalInvest;
  final String totalGold;
  final Price price;
  final String changeType;

  GoldOverviewData({
    required this.totalValue,
    required this.percentChange,
    required this.totalInvest,
    required this.totalGold,
    required this.price,
    required this.changeType,
  });

  factory GoldOverviewData.fromJson(Map<String, dynamic> json) {
    return GoldOverviewData(
      totalValue: json['totalValue'],
      percentChange: json['percentChange'],
      totalInvest: json['totalInvest'],
      totalGold: json['totalGold'],
      price: Price.fromJson(json['price']),
      changeType: json['changeType'],
    );
  }
}

class Price {
  final double currentPrice;
  final int gstPercentage;
  final double priceWithGst;
  final int rateId;
  final String rateValidity;
  final double minimumPurchaseAmount;
  final double minimumGoldQuantity;

  Price({
    required this.currentPrice,
    required this.gstPercentage,
    required this.priceWithGst,
    required this.rateId,
    required this.rateValidity,
    required this.minimumPurchaseAmount,
    required this.minimumGoldQuantity,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      currentPrice: json['currentPrice'].toDouble(),
      gstPercentage: json['gstPercentage'],
      priceWithGst: json['priceWithGst'].toDouble(),
      rateId: json['rateId'],
      rateValidity: json['rateValidity'],
      minimumPurchaseAmount: json['minimumPurchaseAmount'].toDouble(),
      minimumGoldQuantity: json['minimumGoldQuantity'].toDouble(),
    );
  }
}
