import 'add_to_cart_response.dart';

class UpdateCartItemResponse {
  final bool success;
  final String? message;
  final CartDataModel? data;

  const UpdateCartItemResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory UpdateCartItemResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCartItemResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map
          ? CartDataModel.fromJson(
              json['data'] is Map<String, dynamic>
                  ? json['data'] as Map<String, dynamic>
                  : Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
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
