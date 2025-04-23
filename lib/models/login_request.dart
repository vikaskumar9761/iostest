class LoginRequest {
  final String login;
  final String firstName;
  final String lastName;
  final String email;
  final String langKey;
  final String deviceimei;
  final String devicetoken;
  final String phone;
  final String referredBy;

  LoginRequest({
    required this.login,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.langKey = 'en',
    this.deviceimei = '',
    this.devicetoken = '',
    required this.phone,
    this.referredBy = '',
  });

  Map<String, dynamic> toJson() => {
    'login': login,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'langKey': langKey,
    'deviceimei': deviceimei,
    'devicetoken': devicetoken,
    'phone': phone,
    'referredBy': referredBy,
  };
}

// filepath: /Users/frugalisminds/FLUTTER_PROJECT/iostest/lib/models/login_response.dart
class LoginResponse {
  final bool success;
  final String code;
  final LoginData data;
  final String message;

  LoginResponse({
    required this.success,
    required this.code,
    required this.data,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json['success'] ?? false,
    code: json['code'] ?? '',
    data: LoginData.fromJson(json['data'] ?? {}),
    message: json['message'] ?? '',
  );
}

class LoginData {
  final UserData user;

  LoginData({required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    user: UserData.fromJson(json['user'] ?? {}),
  );
}

class UserData {
  final int id;
  final String login;

  UserData({required this.id, required this.login});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json['id'] ?? 0,
    login: json['login'] ?? '',
  );
}