import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/models/models.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final Coupon? appliedCoupon;

  const CartState({
    this.items = const [],
    this.appliedCoupon,
  });

  double get subtotal => items.fold(0.0, (val, element) => val + element.totalPrice);
  double get discountAmount {
    if (appliedCoupon == null) return 0.0;
    double calc = subtotal * (appliedCoupon!.discountPercent / 100);
    return calc > appliedCoupon!.maxDiscount ? appliedCoupon!.maxDiscount : calc;
  }
  double get deliveryFee => items.isEmpty ? 0.0 : 30.0;
  double get total => (subtotal + deliveryFee) - discountAmount;

  CartState copyWith({
    List<CartItem>? items,
    Coupon? appliedCoupon,
    bool clearCoupon = false,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
    );
  }

  @override
  List<Object?> get props => [items, appliedCoupon];
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(FoodItem food) {
    final index = state.items.indexWhere((e) => e.food.id == food.id);
    if (index >= 0) {
      final updatedList = List<CartItem>.from(state.items);
      updatedList[index] = updatedList[index].copyWith(quantity: updatedList[index].quantity + 1);
      emit(state.copyWith(items: updatedList));
    } else {
      emit(state.copyWith(items: [...state.items, CartItem(food: food)]));
    }
  }

  void updateQuantity(FoodItem food, int newQty) {
    if (newQty <= 0) {
      emit(state.copyWith(items: state.items.where((e) => e.food.id != food.id).toList()));
    } else {
      final updatedList = state.items.map((e) {
        if (e.food.id == food.id) {
          return e.copyWith(quantity: newQty);
        }
        return e;
      }).toList();
      emit(state.copyWith(items: updatedList));
    }
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
