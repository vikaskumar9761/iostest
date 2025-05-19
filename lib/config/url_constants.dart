class UrlConstants {
  //static const String baseUrl = 'http://192.168.0.102:8089/api';
  static const String baseUrl = 'https://justb2c.grahaksathi.com/api';
  static const String verifyOtp = '$baseUrl/login/otp/verify';
  static const String profile = '$baseUrl/account';
  static const String config_api = '$baseUrl/api/config';
  static const String profileUpdate =
      '$baseUrl/account'; // Add the profile update endpoint
  static const String hotelsList = '$baseUrl/hotels/city/';
  static const String hotelSearchCity = '$baseUrl/hotels/search/city/';
  static const String goldProfile = '$baseUrl/gold/profile';
  static const String goldHistry =
      '$baseUrl/gold/gold/historical?fromDate=23-02-01&toDate=23-02-02&type=d';
  static const String goldBuyPrice = '$baseUrl/gold/buy/price';
  static const String rechargePlans = '$baseUrl/recharge/plans';
  static const String flight_City_list = '$baseUrl/flights/dom';
  static const String pincode = '$baseUrl/mmtc/isPincode/serviceable?pincode=';
  static const String panVerify = '$baseUrl/pan/verify';
}
