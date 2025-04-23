class UserModel {
  final int id;
  final String login;
  final String firstName;
  final String lastName;
  final String email;
  final bool activated;
  final String? imageUrl;
  final double balance;
  final String userStatus;
  final String refCode;
  final String? address;

  UserModel({
    required this.id,
    required this.login,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.activated,
    this.imageUrl,
    required this.balance,
    required this.userStatus,
    required this.refCode,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      login: json['login'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      activated: json['activated'],
      imageUrl: json['imageUrl'],
      balance: json['balance'].toDouble(),
      userStatus: json['userStatus'],
      refCode: json['refCode'],
      address: json['address'],
    );
  }
}