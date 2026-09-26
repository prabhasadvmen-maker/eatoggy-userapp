class CustomerData {
  final String id;
  final String mobile;
  final String role;
  final bool isMobileVerified;

  const CustomerData({
    required this.id,
    required this.mobile,
    required this.role,
    required this.isMobileVerified,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      role: json['role'] as String? ?? '',
      isMobileVerified: json['isMobileVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': mobile,
      'role': role,
      'isMobileVerified': isMobileVerified,
    };
  }
}

class VerifyOtpData {
  final String token;
  final CustomerData? customer;

  const VerifyOtpData({
    required this.token,
    this.customer,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      token: json['token'] as String? ?? '',
      customer: json['customer'] is Map<String, dynamic>
          ? CustomerData.fromJson(json['customer'] as Map<String, dynamic>)
          : (json['customer'] is Map
              ? CustomerData.fromJson(
                  Map<String, dynamic>.from(json['customer'] as Map),
                )
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'customer': customer?.toJson(),
    };
  }
}

class VerifyOtpResponse {
  final bool success;
  final String message;
  final VerifyOtpData? data;

  const VerifyOtpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] is Map<String, dynamic>
          ? VerifyOtpData.fromJson(json['data'] as Map<String, dynamic>)
          : (json['data'] is Map
              ? VerifyOtpData.fromJson(
                  Map<String, dynamic>.from(json['data'] as Map),
                )
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
