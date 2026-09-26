import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/models/models.dart';
import '../data/models/add_to_cart_request.dart';
import '../data/models/add_to_cart_response.dart';
import '../data/models/get_cart_response.dart';
import '../data/models/update_cart_item_request.dart';
import '../data/models/update_cart_item_response.dart';
import '../data/models/remove_cart_item_response.dart';
import '../data/repositories/cart_repository.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final Coupon? appliedCoupon;
  final bool isLoading;
  final bool isAdding;
  final String? restaurantId;
  final String? error;

  const CartState({
    this.items = const [],
    this.appliedCoupon,
    this.isLoading = false,
    this.isAdding = false,
    this.restaurantId,
    this.error,
  });

  double get subtotal => items.fold(0.0, (val, element) => val + element.totalPrice);
  double get discountAmount {
    if (appliedCoupon == null) return 0.0;
    double calc = subtotal * (appliedCoupon!.discountPercent / 100);
    return calc > appliedCoupon!.maxDiscount ? appliedCoupon!.maxDiscount : calc;
  }
  double get total => subtotal - discountAmount;

  CartState copyWith({
    List<CartItem>? items,
    Coupon? appliedCoupon,
    bool clearCoupon = false,
    bool? isLoading,
    bool? isAdding,
    String? restaurantId,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      restaurantId: restaurantId ?? this.restaurantId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, appliedCoupon, isLoading, isAdding, restaurantId, error];
}

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;

  CartCubit({CartRepository? cartRepository})
      : cartRepository = cartRepository ?? CartRepositoryImpl(),
        super(const CartState());

  Future<GetCartResponse?> fetchCart() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await cartRepository.getCart();
      if (response.success && response.data != null) {
        final backendItems = response.data!.items.map((i) => i.toCartItem()).toList();
        emit(state.copyWith(
          isLoading: false,
          items: backendItems,
          restaurantId: response.data!.restaurantId,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          items: [],
        ));
      }
      return response;
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load cart',
      ));
      return null;
    }
  }

  Future<AddToCartResponse?> addToCart(FoodItem food, {int quantity = 1}) async {
    final validQuantity = quantity < 1 ? 1 : quantity;

    // 1. Optimistic update
    final index = state.items.indexWhere((e) => e.food.id == food.id);
    if (index >= 0) {
      final updatedList = List<CartItem>.from(state.items);
      updatedList[index] = updatedList[index].copyWith(
        quantity: updatedList[index].quantity + validQuantity,
      );
      emit(state.copyWith(items: updatedList));
    } else {
      emit(state.copyWith(items: [
        ...state.items,
        CartItem(food: food, quantity: validQuantity),
      ]));
    }

    // 2. API call to POST /api/cart/items
    try {
      emit(state.copyWith(isAdding: true));
      final request = AddToCartRequest(
        menuItemId: food.id,
        quantity: validQuantity,
      );
      final response = await cartRepository.addToCart(request);
      if (response.success && response.data != null && response.data!.items.isNotEmpty) {
        final syncedItems = response.data!.items.map((i) => i.toCartItem()).toList();
        emit(state.copyWith(
          isAdding: false,
          items: syncedItems,
          restaurantId: response.data!.restaurantId,
        ));
      } else {
        emit(state.copyWith(isAdding: false));
      }
      return response;
    } catch (e) {
      emit(state.copyWith(isAdding: false));
      return null;
    }
  }

  Future<AddToCartResponse?> addToCartByMenuItemId({
    required String menuItemId,
    int quantity = 1,
  }) async {
    final validQuantity = quantity < 1 ? 1 : quantity;

    try {
      emit(state.copyWith(isAdding: true));
      final request = AddToCartRequest(
        menuItemId: menuItemId,
        quantity: validQuantity,
      );
      final response = await cartRepository.addToCart(request);
      if (response.success && response.data != null && response.data!.items.isNotEmpty) {
        final syncedItems = response.data!.items.map((i) => i.toCartItem()).toList();
        emit(state.copyWith(
          isAdding: false,
          items: syncedItems,
          restaurantId: response.data!.restaurantId,
        ));
      } else {
        emit(state.copyWith(isAdding: false));
      }
      return response;
    } catch (e) {
      emit(state.copyWith(isAdding: false));
      return null;
    }
  }

  Future<dynamic> updateQuantity(dynamic itemOrFood, int newQty) async {
    if (newQty <= 0) {
      return await removeFromCart(itemOrFood);
    }
    final validQty = newQty;

    CartItem? cartItem;
    FoodItem? food;

    if (itemOrFood is CartItem) {
      cartItem = itemOrFood;
      food = itemOrFood.food;
    } else if (itemOrFood is FoodItem) {
      food = itemOrFood;
      final idx = state.items.indexWhere((e) => e.food.id == itemOrFood.id);
      if (idx >= 0) {
        cartItem = state.items[idx];
      }
    }

    if (cartItem == null && food == null) return null;

    final String itemId = (cartItem?.cartItemId != null && cartItem!.cartItemId!.isNotEmpty)
        ? cartItem.cartItemId!
        : (food?.id ?? '');

    // 1. Optimistic update
    final previousItems = List<CartItem>.from(state.items);
    final updatedList = state.items.map((e) {
      final matchesCartItem = cartItem != null &&
          ((cartItem.cartItemId != null && cartItem.cartItemId == e.cartItemId) ||
              cartItem.food.id == e.food.id);
      final matchesFood = food != null && e.food.id == food.id;

      if (matchesCartItem || matchesFood) {
        return e.copyWith(quantity: validQty);
      }
      return e;
    }).toList();

    emit(state.copyWith(items: updatedList));

    // 2. Call backend API: PATCH/PUT {{baseUrl}}/api/cart/items/:itemId
    if (itemId.isNotEmpty) {
      try {
        final request = UpdateCartItemRequest(quantity: validQty);
        UpdateCartItemResponse? response;
        try {
          response = await cartRepository.updateCartItem(itemId, request);
        } catch (e) {
          // If itemId failed (e.g. 404 or 400) and food.id is different, try with food.id as fallback
          if (food != null && food.id.isNotEmpty && food.id != itemId) {
            response = await cartRepository.updateCartItem(food.id, request);
          } else {
            rethrow;
          }
        }

        if (response.success &&
            response.data != null &&
            response.data!.items.isNotEmpty) {
          final syncedItems =
              response.data!.items.map((i) => i.toCartItem()).toList();
          emit(state.copyWith(
            items: syncedItems,
            restaurantId: response.data!.restaurantId,
          ));
        }
        return response;
      } catch (e) {
        // Revert to previous state if network call fails
        emit(state.copyWith(items: previousItems));
        return null;
      }
    }

    return null;
  }

  Future<RemoveCartItemResponse?> removeFromCart(dynamic itemOrFood) async {
    CartItem? cartItem;
    FoodItem? food;

    if (itemOrFood is CartItem) {
      cartItem = itemOrFood;
      food = itemOrFood.food;
    } else if (itemOrFood is FoodItem) {
      food = itemOrFood;
      final idx = state.items.indexWhere((e) => e.food.id == itemOrFood.id);
      if (idx >= 0) {
        cartItem = state.items[idx];
      }
    }

    if (cartItem == null && food == null) return null;

    final String itemId = (cartItem?.cartItemId != null && cartItem!.cartItemId!.isNotEmpty)
        ? cartItem.cartItemId!
        : (food?.id ?? '');

    // 1. Optimistic removal
    final previousItems = List<CartItem>.from(state.items);
    final previousRestaurantId = state.restaurantId;
    final updatedList = state.items.where((e) {
      final matchesCartItem = cartItem != null &&
          ((cartItem.cartItemId != null && cartItem.cartItemId == e.cartItemId) ||
              cartItem.food.id == e.food.id);
      final matchesFood = food != null && e.food.id == food.id;
      return !(matchesCartItem || matchesFood);
    }).toList();

    emit(state.copyWith(
      items: updatedList,
      restaurantId: updatedList.isEmpty ? null : state.restaurantId,
    ));

    // 2. Call backend API: DELETE {{baseUrl}}/api/cart/items/:itemId
    if (itemId.isNotEmpty) {
      try {
        RemoveCartItemResponse? response;
        try {
          response = await cartRepository.removeCartItem(itemId);
        } catch (e) {
          // If itemId failed and food.id is different, try with food.id as fallback
          if (food != null && food.id.isNotEmpty && food.id != itemId) {
            response = await cartRepository.removeCartItem(food.id);
          } else {
            rethrow;
          }
        }

        if (response.success && response.data != null) {
          final syncedItems =
              response.data!.items.map((i) => i.toCartItem()).toList();
          emit(state.copyWith(
            items: syncedItems,
            restaurantId: response.data!.restaurantId,
          ));
        }
        return response;
      } catch (e) {
        // Revert to previous state if network call fails
        emit(state.copyWith(
          items: previousItems,
          restaurantId: previousRestaurantId,
        ));
        return null;
      }
    }

    return null;
  }

  void applyCoupon(Coupon coupon) {
    if (state.subtotal >= coupon.minOrderValue) {
      emit(state.copyWith(appliedCoupon: coupon));
    }
  }

  void removeCoupon() {
    emit(state.copyWith(clearCoupon: true));
  }

  void clearCart() {
    emit(const CartState());
  }
}
