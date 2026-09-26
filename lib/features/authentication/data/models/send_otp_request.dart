class SendOtpRequest {
  final String mobile;

  const SendOtpRequest({
    required this.mobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
    };
  }

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) {
    return SendOtpRequest(
      mobile: json['mobile'] as String? ?? '',
    );
  }
}
