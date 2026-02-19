class ResponseStatusM {
  final int status_code;
  final String? message;
  final dynamic data;
  final int time;

  ResponseStatusM({
    required this.status_code,
    this.message,
    this.data,
    int? time, // Accept nullable time in the constructor
  }) : time = time ??
            DateTime.now().millisecondsSinceEpoch; // Initialize properly

  factory ResponseStatusM.fromJson(Map<String, dynamic> json) {
    return ResponseStatusM(
      status_code: json['status_code'] as int,
      message: json['message'] as String?,
      data: json['data'],
      time: json['time'] as int?, // Pass nullable time
    );
  }

  Map<String, dynamic> toJson() => {
        'status_code': status_code,
        'message': message,
        'data': data,
        'time': time,
      };

  @override
  String toString() {
    return '''
    ResponseStatusM {
      status_code: $status_code,
      message: $message,
      data: $data,
      time: $time (${DateTime.fromMillisecondsSinceEpoch(time)})
    }''';
  }
}
