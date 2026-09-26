class DeleteAddressResponse {
  final bool success;
  final String message;

  const DeleteAddressResponse({
    required this.success,
    required this.message,
  });

  factory DeleteAddressResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAddressResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
