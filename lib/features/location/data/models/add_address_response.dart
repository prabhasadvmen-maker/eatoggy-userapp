class CustomerAddressData {
  final String id;
  final String customerId;
  final String name;
  final String mobile;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final String label;
  final bool isDefault;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  const CustomerAddressData({
    required this.id,
    required this.customerId,
    required this.name,
    required this.mobile,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    required this.label,
    required this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CustomerAddressData.fromJson(Map<String, dynamic> json) {
    return CustomerAddressData(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      landmark: json['landmark'] as String?,
      label: json['label'] as String? ?? 'Home',
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'name': name,
      'mobile': mobile,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
      'label': label,
      'isDefault': isDefault,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class AddAddressResponse {
  final bool success;
  final String message;
  final CustomerAddressData? data;

  const AddAddressResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AddAddressResponse.fromJson(Map<String, dynamic> json) {
    return AddAddressResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] is Map<String, dynamic>
          ? CustomerAddressData.fromJson(json['data'] as Map<String, dynamic>)
          : (json['data'] is Map
              ? CustomerAddressData.fromJson(
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
