class SendOtpResponse {
  final bool success;
  final String message;
  final dynamic data;

  const SendOtpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}
