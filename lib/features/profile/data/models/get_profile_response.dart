class ProfileCustomer {
  final String id;
  final String mobile;
  final String role;
  final bool isActive;
  final bool isMobileVerified;
  final String? lastLogin;
  final String? createdAt;
  final String? updatedAt;

  const ProfileCustomer({
    required this.id,
    required this.mobile,
    required this.role,
    required this.isActive,
    required this.isMobileVerified,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileCustomer.fromJson(Map<String, dynamic> json) {
    return ProfileCustomer(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      role: json['role'] as String? ?? 'Customer',
      isActive: json['isActive'] as bool? ?? true,
      isMobileVerified: json['isMobileVerified'] as bool? ?? false,
      lastLogin: json['lastLogin'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': mobile,
      'role': role,
      'isActive': isActive,
      'isMobileVerified': isMobileVerified,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class GetProfileData {
  final ProfileCustomer? customer;

  const GetProfileData({
    this.customer,
  });

  factory GetProfileData.fromJson(Map<String, dynamic> json) {
    return GetProfileData(
      customer: json['customer'] is Map<String, dynamic>
          ? ProfileCustomer.fromJson(json['customer'] as Map<String, dynamic>)
          : (json['customer'] is Map
              ? ProfileCustomer.fromJson(
                  Map<String, dynamic>.from(json['customer'] as Map),
                )
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customer?.toJson(),
    };
  }
}

class GetProfileResponse {
  final bool success;
  final String message;
  final GetProfileData? data;

  const GetProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) {
    return GetProfileResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] is Map<String, dynamic>
          ? GetProfileData.fromJson(json['data'] as Map<String, dynamic>)
          : (json['data'] is Map
              ? GetProfileData.fromJson(
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
