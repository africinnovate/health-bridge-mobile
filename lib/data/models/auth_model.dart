class RegisterModel {
  String email;
  String role;
  String password;
  // String firstName;
  // String lastName;
  // String gender;
  // String phone;

  RegisterModel({
    required this.email,
    required this.password,
    required this.role,
    // required this.firstName,
    // required this.lastName,
    // required this.gender,
    // required this.phone,
  });

  // Convert JSON to RegisterModel
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      // firstName: json['first_name'] ?? '',
      // lastName: json['last_name'] ?? '',
      // gender: json['gender'] ?? '',
      // phone: json['phone'] ?? '',
    );
  }

  // Convert RegisterModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
      // 'first_name': firstName,
      // 'last_name': lastName,
      // 'gender': gender,
      // 'phone': phone,
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
