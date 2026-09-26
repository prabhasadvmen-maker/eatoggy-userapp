import 'add_address_response.dart';

class GetAddressesResponse {
  final bool success;
  final String message;
  final List<CustomerAddressData> data;

  const GetAddressesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetAddressesResponse.fromJson(Map<String, dynamic> json) {
    List<CustomerAddressData> addressList = [];

    if (json['data'] is List) {
      final list = json['data'] as List;
      addressList = list
          .whereType<Map>()
          .map((item) => CustomerAddressData.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return GetAddressesResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: addressList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
