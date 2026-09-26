class AddAddressRequest {
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

  const AddAddressRequest({
    required this.name,
    required this.mobile,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.label = 'Home',
    this.isDefault = true,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name.trim(),
      'mobile': mobile.trim(),
      'addressLine1': addressLine1.trim(),
      'addressLine2': addressLine2.trim(),
      'city': city.trim(),
      'state': state.trim(),
      'pincode': pincode.trim(),
      'label': label,
      'isDefault': isDefault,
    };
    if (landmark != null && landmark!.trim().isNotEmpty) {
      map['landmark'] = landmark!.trim();
    } else {
      map['landmark'] = '';
    }
    return map;
  }

  factory AddAddressRequest.fromJson(Map<String, dynamic> json) {
    return AddAddressRequest(
      name: json['name'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      landmark: json['landmark'] as String?,
      label: json['label'] as String? ?? 'Home',
      isDefault: json['isDefault'] as bool? ?? true,
    );
  }
}
