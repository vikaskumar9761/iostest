class PanInfoResponse {
  final bool success;
  final String code;
  final dynamic data; // `null` or any type, customize if needed
  final String message;

  PanInfoResponse({
    required this.success,
    required this.code,
    this.data,
    required this.message,
  });

  factory PanInfoResponse.fromJson(Map<String, dynamic> json) {
    return PanInfoResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      data: json['data'], // null or actual object
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'data': data,
      'message': message,
    };
  }
}
