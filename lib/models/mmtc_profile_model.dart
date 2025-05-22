class CreateProfileResponse {
  final bool success;
  final String? code;
  final dynamic data;
  final String? message;

  CreateProfileResponse({
    required this.success,
    this.code,
    this.data,
    this.message,
  });

  factory CreateProfileResponse.fromJson(Map<String, dynamic> json) {
    return CreateProfileResponse(
      success: json['success'] ?? false,
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }
}
