class ProfileResponse {
  final bool success;
  final String code;
  final ProfileData data;
  final String message;

  ProfileResponse({
    required this.success,
    required this.code,
    required this.data,
    required this.message,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    success: json['success'] ?? false,
    code: json['code'] ?? '',
    data: ProfileData.fromJson(json['data'] ?? {}),
    message: json['message'] ?? '',
  );
}

class ProfileData {
  final int id;
  final String login;
  final String firstName;
  final String lastName;
  final String email;
  final String? imageUrl;
  final bool activated;
  final String langKey;
  final double balance;
  final String? pan;
  final String? aadhar;
  final String phone;
  final String refCode;
  final String? address;
  final String? pinCode;

  ProfileData({
    required this.id,
    required this.login,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.imageUrl,
    required this.activated,
    required this.langKey,
    required this.balance,
    this.pan,
    this.aadhar,
    required this.phone,
    required this.refCode,
    this.address,
    this.pinCode,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json['id'] ?? 0,
        login: json['login'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'] ?? '',
        imageUrl: json['imageUrl'],
        activated: json['activated'] ?? false,
        langKey: json['langKey'] ?? '',
        balance: (json['balance'] ?? 0.0).toDouble(),
        pan: json['pan'],
        aadhar: json['aadhar'],
        phone: json['phone'] ?? '',
        refCode: json['refCode'] ?? '',
        address: json['address'],
        pinCode: json['pinCode'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'imageUrl': imageUrl,
        'activated': activated,
        'langKey': langKey,
        'balance': balance,
        'pan': pan,
        'aadhar': aadhar,
        'phone': phone,
        'refCode': refCode,
        'address': address,
        'pinCode': pinCode,
      };

}