class FlightSearchResponse {
  final bool success;
  final String code;
  final FlightData data;
  final String message;

  FlightSearchResponse({
    required this.success,
    required this.code,
    required this.data,
    required this.message,
  });

  factory FlightSearchResponse.fromJson(Map<String, dynamic> json) {
    return FlightSearchResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      data: FlightData.fromJson(json['data']),
      message: json['message'] ?? '',
    );
  }
}

class FlightData {
  final List<FlightItem> onw;

  FlightData({required this.onw});

  factory FlightData.fromJson(Map<String, dynamic> json) {
    var list = json['onw'] as List? ?? [];
    return FlightData(
      onw: list.map((e) => FlightItem.fromJson(e)).toList(),
    );
  }
}

class FlightItem {
  final String searchKey;
  final String from;
  final String to;
  final String flightname;
  final String flghtcode;
  final String price;
  final String? basicPrice;
  final String? taxAmount;
  final String? totalAmount;
  final String duration;
  final String stops;
  final String arrivalTime;
  final String depTime;
  final String depDate;
  final String arrivalDate;
  final String aircraftCode;
  final bool hasLayover;
  final bool isrefundable;
  final String? cabin;
  final String? depTerminal;
  final String? arrivalTerminal;
  final String totalDuration;
  final dynamic layover;
  final List<dynamic> layovers;
  final List<PaxFare> paxFare;
  final String justpeSearchId;
  final dynamic bondDetails;
  final bool domestic;

  FlightItem({
    required this.searchKey,
    required this.from,
    required this.to,
    required this.flightname,
    required this.flghtcode,
    required this.price,
    this.basicPrice,
    this.taxAmount,
    this.totalAmount,
    required this.duration,
    required this.stops,
    required this.arrivalTime,
    required this.depTime,
    required this.depDate,
    required this.arrivalDate,
    required this.aircraftCode,
    required this.hasLayover,
    required this.isrefundable,
    this.cabin,
    this.depTerminal,
    this.arrivalTerminal,
    required this.totalDuration,
    this.layover,
    required this.layovers,
    required this.paxFare,
    required this.justpeSearchId,
    this.bondDetails,
    required this.domestic,
  });

  factory FlightItem.fromJson(Map<String, dynamic> json) {
    return FlightItem(
      searchKey: json['searchKey'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      flightname: json['flightname'] ?? '',
      flghtcode: json['flghtcode'] ?? '',
      price: json['price'] ?? '',
      basicPrice: json['basicPrice'],
      taxAmount: json['taxAmount'],
      totalAmount: json['totalAmount'],
      duration: json['duration'] ?? '',
      stops: json['stops'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      depTime: json['depTime'] ?? '',
      depDate: json['depDate'] ?? '',
      arrivalDate: json['arrivalDate'] ?? '',
      aircraftCode: json['aircraftCode'] ?? '',
      hasLayover: json['hasLayover'] ?? false,
      isrefundable: json['isrefundable'] ?? false,
      cabin: json['cabin'],
      depTerminal: json['depTerminal'],
      arrivalTerminal: json['arrivalTerminal'],
      totalDuration: json['totalDuration'] ?? '',
      layover: json['layover'],
      layovers: json['layovers'] ?? [],
      paxFare: (json['paxFare'] as List? ?? []).map((e) => PaxFare.fromJson(e)).toList(),
      justpeSearchId: json['justpeSearchId'] ?? '',
      bondDetails: json['bondDetails'],
      domestic: json['domestic'] ?? false,
    );
  }
}

class PaxFare {
  final String? airlinePnr;
  final String? baggageUnit;
  final String? baggageWeight;
  final double? basicFare;
  final dynamic boundType;
  final double? cgst;
  final double? cancelPenalty;
  final double? changePenalty;
  final bool? changeable;
  final double? igst;
  final int? paxType;
  final bool? refundable;
  final double? sgst;
  final double? serviceFee;
  final double? tds;
  final double? tolValue;
  final double? totalFare;
  final double? totalTax;
  final double? transactionAmount;
  final double? transactionFee;

  PaxFare({
    this.airlinePnr,
    this.baggageUnit,
    this.baggageWeight,
    this.basicFare,
    this.boundType,
    this.cgst,
    this.cancelPenalty,
    this.changePenalty,
    this.changeable,
    this.igst,
    this.paxType,
    this.refundable,
    this.sgst,
    this.serviceFee,
    this.tds,
    this.tolValue,
    this.totalFare,
    this.totalTax,
    this.transactionAmount,
    this.transactionFee,
  });

  factory PaxFare.fromJson(Map<String, dynamic> json) {
    return PaxFare(
      airlinePnr: json['AirlinePnr'],
      baggageUnit: json['BaggageUnit'],
      baggageWeight: json['BaggageWeight'],
      basicFare: (json['BasicFare'] as num?)?.toDouble(),
      boundType: json['BoundType'],
      cgst: (json['CGST'] as num?)?.toDouble(),
      cancelPenalty: (json['CancelPenalty'] as num?)?.toDouble(),
      changePenalty: (json['ChangePenalty'] as num?)?.toDouble(),
      changeable: json['Changeable'],
      igst: (json['IGST'] as num?)?.toDouble(),
      paxType: json['PaxType'],
      refundable: json['Refundable'],
      sgst: (json['SGST'] as num?)?.toDouble(),
      serviceFee: (json['ServiceFee'] as num?)?.toDouble(),
      tds: (json['TDS'] as num?)?.toDouble(),
      tolValue: (json['TolValue'] as num?)?.toDouble(),
      totalFare: (json['TotalFare'] as num?)?.toDouble(),
      totalTax: (json['TotalTax'] as num?)?.toDouble(),
      transactionAmount: (json['TransactionAmount'] as num?)?.toDouble(),
      transactionFee: (json['TransactionFee'] as num?)?.toDouble(),
    );
  }
}