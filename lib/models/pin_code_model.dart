class PinCodeResponse {
  final bool success;
  final String code;
  final PinCodeData data;
  final String message;

  PinCodeResponse({
    required this.success,
    required this.code,
    required this.data,
    required this.message,
  });

  factory PinCodeResponse.fromJson(Map<String, dynamic> json) {
    return PinCodeResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      data: PinCodeData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class PinCodeData {
  final bool serviceable;
  final String pincode;
  final String state;
  final String statecode;
  final String city;
  final String deliveryInDays;

  PinCodeData({
    required this.serviceable,
    required this.pincode,
    required this.state,
    required this.statecode,
    required this.city,
    required this.deliveryInDays,
  });

  factory PinCodeData.fromJson(Map<String, dynamic> json) {
    return PinCodeData(
      serviceable: json['serviceable'] ?? false,
      pincode: json['pincode'] ?? '',
      state: json['state'] ?? '',
      statecode: json['statecode'] ?? '',
      city: json['city'] ?? '',
      deliveryInDays: json['deliveryInDays'] ?? '',
    );
  }
}