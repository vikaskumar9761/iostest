class GoldProfileData {
  final String mmtcBal;
  final String safegoldBal;
  final bool mmtc;
  final bool safegold;

  GoldProfileData({
    required this.mmtcBal,
    required this.safegoldBal,
    required this.mmtc,
    required this.safegold,
  });

  factory GoldProfileData.fromJson(Map<String, dynamic> json) {
    return GoldProfileData(
      mmtcBal: json['mmtcBal'].toString(), // Convert int to String
      safegoldBal: json['safegoldBal'].toString(), // Convert int to String
      mmtc: json['mmtc'] ,
      safegold: json['safegold'] ,
    );
  }
}

class GoldProfileResponse {
  final bool success;
  final String code;
  final GoldProfileData data;
  final String message;

  GoldProfileResponse({
    required this.success,
    required this.code,
    required this.data,
    required this.message,
  });

  factory GoldProfileResponse.fromJson(Map<String, dynamic> json) {
    return GoldProfileResponse(
      success: json['success'] ,
      code: json['code'].toString(), // Convert int to String if necessary
      data: GoldProfileData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}