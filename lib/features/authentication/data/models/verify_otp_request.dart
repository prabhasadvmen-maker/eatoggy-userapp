class VerifyOtpRequest {
  final String mobile;
  final String otp;

  const VerifyOtpRequest({
    required this.mobile,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'otp': otp,
    };
  }

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequest(
      mobile: json['mobile'] as String? ?? '',
      otp: json['otp'] as String? ?? '',
    );
  }
}
