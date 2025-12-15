class RegisterModel {
  String email;
  String firstName;
  String lastName;
  String gender;
  String password;
  String phone;
  String role;

  RegisterModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.password,
    required this.phone,
    required this.role,
  });

  // Convert JSON to RegisterModel
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }

  // Convert RegisterModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'password': password,
      'phone': phone,
      'role': role,
    };
  }
}

/*
Your register returns data in the following format:
{
  "token": "string",
  "user": {
    "email": "string",
    "first_name": "string",
    "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "last_name": "string",
    "role": "string"
  }
}

recommended model structure above.
{
  "statusCode": 200,
  "message": "string",
  "data": {
    "token": "string",
    "email": "string",
    "first_name": "string",
    "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "last_name": "string",
    "role": "string"
  }

 */
