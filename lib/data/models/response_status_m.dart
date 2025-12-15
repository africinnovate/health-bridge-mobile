class ResponseStatusM {
  final int code;
  final String? message;
  final dynamic data;
  final int time; // Remove nullable type (since it always has a value)

  ResponseStatusM({
    required this.code,
    this.message,
    this.data,
    int? time, // Accept nullable time in the constructor
  }) : time = time ??
            DateTime.now().millisecondsSinceEpoch; // Initialize properly

  factory ResponseStatusM.fromJson(Map<String, dynamic> json) {
    return ResponseStatusM(
      code: json['code'] as int,
      message: json['message'] as String?,
      data: json['data'],
      time: json['time'] as int?, // Pass nullable time
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data,
        'time': time,
      };

  @override
  String toString() {
    return '''
    ResponseStatusM {
      code: $code,
      message: $message,
      data: $data,
      time: $time (${DateTime.fromMillisecondsSinceEpoch(time)})
    }''';
  }
}
