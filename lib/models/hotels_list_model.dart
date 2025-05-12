class HotelsListResponse {
  final String? checkInDate;
  final String? checkOutDate;
  final String? error;
  final int hotelCount;
  final int nights;
  final String? timeSpan;
  final int totalHotel;
  final int elapsedTime;
  final String? et;
  final List<HotelItem> hotellist;
  final String? htlPlcy;
  final String? insertedon;
  final String? ipaddress;
  final String? responsetime;
  final String? sessionID;
  final String? traceid;
  final String? username;
  final String? vid;

  HotelsListResponse({
    this.checkInDate,
    this.checkOutDate,
    this.error,
    required this.hotelCount,
    required this.nights,
    this.timeSpan,
    required this.totalHotel,
    required this.elapsedTime,
    this.et,
    required this.hotellist,
    this.htlPlcy,
    this.insertedon,
    this.ipaddress,
    this.responsetime,
    this.sessionID,
    this.traceid,
    this.username,
    this.vid,
  });

  factory HotelsListResponse.fromJson(Map<String, dynamic> json) {
    return HotelsListResponse(
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      error: json['error'],
      hotelCount: json['hotelCount'] ?? 0,
      nights: json['nights'] ?? 0,
      timeSpan: json['timeSpan'],
      totalHotel: json['totalHotel'] ?? 0,
      elapsedTime: json['elapsedTime'] ?? 0,
      et: json['et'],
      hotellist: (json['hotellist'] as List<dynamic>? ?? [])
          .map((e) => HotelItem.fromJson(e))
          .toList(),
      htlPlcy: json['htlPlcy'],
      insertedon: json['insertedon'],
      ipaddress: json['ipaddress'],
      responsetime: json['responsetime'],
      sessionID: json['sessionID'],
      traceid: json['traceid'],
      username: json['username'],
      vid: json['vid'],
    );
  }
}

class HotelItem {
  final double tripAdvisorRating;
  final String tripAdvisorRatingUrl;
  final int tripAdvisorReviewCount;
  final String tripAdvisorReviewUrl;
  final String? category;
  final String? chName;
  final String? checkInTime;
  final String? checkOutTime;
  final String? couponCode;
  final String? distance;
  final String? emtCommonID;
  final String? et;
  final int? engineType;
  final String? hotelHighlights;
  final String? imageThumbUrl;
  final String? inclusions;
  final bool isBreakFast;
  final bool isCached;
  final bool isDND;
  final bool isDefaultValue;
  final bool isMetaDND;
  final bool isSafety;
  final String? location;
  final bool mostViewed;
  final int mostViewedNo;
  final String? promoDescription;
  final int recommended;
  final String? suppDetails;
  final double totalPrice;
  final String? address;
  final double cdValue;
  final String? city;
  final String? currencyCode;
  final double dfValue;
  final double diffValue;
  final String? giataId;
  final double hdiscount;
  final String? hotelID;
  final String? hotelName;
  final String? htlPlcy;
  final String? latitude;
  final String? longitude;
  final String? nUrl;
  final String? nidhiRating;
  final String? plcy;
  final double price;
  final String? ranking;
  final String? rankingOutOf;
  final String? rating;
  final double surchargeTotal;
  final String? tripType;
  final String? tripId;

  HotelItem({
    required this.tripAdvisorRating,
    required this.tripAdvisorRatingUrl,
    required this.tripAdvisorReviewCount,
    required this.tripAdvisorReviewUrl,
    this.category,
    this.chName,
    this.checkInTime,
    this.checkOutTime,
    this.couponCode,
    this.distance,
    this.emtCommonID,
    this.et,
    this.engineType,
    this.hotelHighlights,
    this.imageThumbUrl,
    this.inclusions,
    required this.isBreakFast,
    required this.isCached,
    required this.isDND,
    required this.isDefaultValue,
    required this.isMetaDND,
    required this.isSafety,
    this.location,
    required this.mostViewed,
    required this.mostViewedNo,
    this.promoDescription,
    required this.recommended,
    this.suppDetails,
    required this.totalPrice,
    this.address,
    required this.cdValue,
    this.city,
    this.currencyCode,
    required this.dfValue,
    required this.diffValue,
    this.giataId,
    required this.hdiscount,
    this.hotelID,
    this.hotelName,
    this.htlPlcy,
    this.latitude,
    this.longitude,
    this.nUrl,
    this.nidhiRating,
    this.plcy,
    required this.price,
    this.ranking,
    this.rankingOutOf,
    this.rating,
    required this.surchargeTotal,
    this.tripType,
    this.tripId,
  });

  factory HotelItem.fromJson(Map<String, dynamic> json) {
    return HotelItem(
      tripAdvisorRating: (json['tripAdvisorRating'] ?? 0.0).toDouble(),
      tripAdvisorRatingUrl: json['tripAdvisorRatingUrl'] ?? '',
      tripAdvisorReviewCount: json['tripAdvisorReviewCount'] ?? 0,
      tripAdvisorReviewUrl: json['tripAdvisorReviewUrl'] ?? '',
      category: json['Category'],
      chName: json['chName'],
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
      couponCode: json['CouponCode'],
      distance: json['Distance'],
      emtCommonID: json['EMTCommonID'],
      et: json['Et'],
      engineType: json['EngineType'],
      hotelHighlights: json['HotelHighlights'],
      imageThumbUrl: json['ImageThumbUrl'],
      inclusions: json['Inclusions'],
      isBreakFast: json['IsBreakFast'] ?? false,
      isCached: json['IsCached'] ?? false,
      isDND: json['IsDND'] ?? false,
      isDefaultValue: json['IsDefaultValue'] ?? false,
      isMetaDND: json['IsMetaDND'] ?? false,
      isSafety: json['IsSafety'] ?? false,
      location: json['Location'],
      mostViewed: json['MostViewed'] ?? false,
      mostViewedNo: json['MostViewedNo'] ?? 0,
      promoDescription: json['PromoDescription'],
      recommended: json['Recommended'] ?? 0,
      suppDetails: json['SuppDetails'],
      totalPrice: (json['TotalPrice'] ?? 0.0).toDouble(),
      address: json['address'],
      cdValue: (json['CdValue'] ?? 0.0).toDouble(),
      city: json['City'],
      currencyCode: json['CurrencyCode'],
      dfValue: (json['DfValue'] ?? 0.0).toDouble(),
      diffValue: (json['DiffValue'] ?? 0.0).toDouble(),
      giataId: json['GiataId'],
      hdiscount: (json['Hdiscount'] ?? 0.0).toDouble(),
      hotelID: json['HotelID'],
      hotelName: json['hotelName'],
      htlPlcy: json['HtlPlcy'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      nUrl: json['NUrl'],
      nidhiRating: json['NidhiRating'],
      plcy: json['Plcy'],
      price: (json['price'] ?? 0.0).toDouble(),
      ranking: json['ranking'],
      rankingOutOf: json['RankingOutOf'],
      rating: json['rating'],
      surchargeTotal: (json['SurchargeTotal'] ?? 0.0).toDouble(),
      tripType: json['TripType'],
      tripId: json['TripId'],
    );
  }
}