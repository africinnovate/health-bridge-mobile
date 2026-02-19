///email, password, role
class RegisterModel {
  String email;
  String role;
  String password;

  RegisterModel({
    required this.email,
    required this.password,
    this.role = '', // ignore for login
  });

  // Convert JSON to RegisterModel
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
    );
  }

  // Convert RegisterModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
    };
  }
}

/// token, refresh_token, userModel
class AuthDataModel {
  final String? token;
  final String? refresh_token;
  final UserModel user;

  AuthDataModel({
    required this.token,
    required this.user,
    required this.refresh_token,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      token: json['token'] as String?,
      refresh_token: json['refresh_token'] as String?,
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refresh_token,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return 'AuthDataModel(token: ${token != null}, refreshToken: ${refresh_token != null})';
  }
}

/// id, email, first_name, last_name, role
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
    };
  }
}
