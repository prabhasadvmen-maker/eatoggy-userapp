import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/add_to_cart_request.dart';
import '../models/add_to_cart_response.dart';
import '../models/get_cart_response.dart';

import '../models/update_cart_item_request.dart';
import '../models/update_cart_item_response.dart';
import '../models/remove_cart_item_response.dart';

abstract class CartRepository {
  Future<AddToCartResponse> addToCart(AddToCartRequest request);
  Future<GetCartResponse> getCart();
  Future<UpdateCartItemResponse> updateCartItem(
    String itemId,
    UpdateCartItemRequest request,
  );
  Future<RemoveCartItemResponse> removeCartItem(String itemId);
}

class CartRepositoryImpl implements CartRepository {
  final Dio _dio;

  CartRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<AddToCartResponse> addToCart(AddToCartRequest request) async {
    final response = await _dio.post(
      ApiConstants.cartItems,
      data: request.toJson(),
    );

    final Map<String, dynamic> responseData =
        response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : (response.data is Map
                ? Map<String, dynamic>.from(response.data as Map)
                : <String, dynamic>{});

    return AddToCartResponse.fromJson(responseData);
  }

  @override
  Future<GetCartResponse> getCart() async {
    final response = await _dio.get(ApiConstants.cart);

    final Map<String, dynamic> responseData =
        response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : (response.data is Map
                ? Map<String, dynamic>.from(response.data as Map)
                : <String, dynamic>{});

    return GetCartResponse.fromJson(responseData);
  }

  @override
  Future<UpdateCartItemResponse> updateCartItem(
    String itemId,
    UpdateCartItemRequest request,
  ) async {
    Response response;
    try {
      response = await _dio.patch(
        ApiConstants.cartItem(itemId),
        data: request.toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
        response = await _dio.put(
          ApiConstants.cartItem(itemId),
          data: request.toJson(),
        );
      } else {
        rethrow;
      }
    }

    final Map<String, dynamic> responseData =
        response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : (response.data is Map
                ? Map<String, dynamic>.from(response.data as Map)
                : <String, dynamic>{});

    return UpdateCartItemResponse.fromJson(responseData);
  }

  @override
  Future<RemoveCartItemResponse> removeCartItem(String itemId) async {
    final response = await _dio.delete(ApiConstants.cartItem(itemId));

    final Map<String, dynamic> responseData =
        response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : (response.data is Map
                ? Map<String, dynamic>.from(response.data as Map)
                : <String, dynamic>{});

    return RemoveCartItemResponse.fromJson(responseData);
  }
}
