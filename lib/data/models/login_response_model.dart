class LoginResponseModel {
  final bool status;
  final String message;
  final String token;
  final bool isSuperuser;
  final UserDetails userDetails;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.isSuperuser,
    required this.userDetails,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
      token: json['token'],
      isSuperuser: json['is_superuser'],
      userDetails: UserDetails.fromJson(json['user_details']),
    );
  }
}

class UserDetails {
  final int id;
  final String? lastLogin;
  final String name;
  final String phone;
  final String address;
  final String mail;
  final String username;
  final String password;
  final String passwordText;
  final int admin;
  final bool isAdmin;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final dynamic branch;

  UserDetails({
    required this.id,
    required this.lastLogin,
    required this.name,
    required this.phone,
    required this.address,
    required this.mail,
    required this.username,
    required this.password,
    required this.passwordText,
    required this.admin,
    required this.isAdmin,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.branch,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      lastLogin: json['last_login'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      mail: json['mail'],
      username: json['username'],
      password: json['password'],
      passwordText: json['password_text'],
      admin: json['admin'],
      isAdmin: json['is_admin'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      branch: json['branch'],
    );
  }
}
