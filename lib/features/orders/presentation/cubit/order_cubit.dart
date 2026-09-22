import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/models/models.dart';

class OrderState extends Equatable {
  final List<Order> orders;
  final bool isLoading;

  const OrderState({
    this.orders = const [],
    this.isLoading = false,
  });

  OrderState copyWith({
    List<Order>? orders,
    bool? isLoading,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading];
}

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  void addOrder(Order order) {
    emit(state.copyWith(orders: [order, ...state.orders]));
  }

  void updateOrderStatus(String orderId, String status) {
    final updated = state.orders.map((o) {
      if (o.id == orderId) {
        return o.copyWith(status: status);
      }
      return o;
    }).toList();
    emit(state.copyWith(orders: updated));
  }
}
