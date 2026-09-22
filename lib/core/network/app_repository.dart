import 'dart:async';
import '../../shared/models/models.dart';
import '../../shared/models/dummy_data.dart';

abstract class AppRepository {
  Future<List<FoodItem>> getFoodItems();
  Future<List<Category>> getCategories();
  Future<List<Coupon>> getCoupons();
  Future<List<SubscriptionPlan>> getSubscriptionPlans();
  Future<Order> placeOrder(List<CartItem> items, double discount, Address address);
  Future<Subscription> subscribeToPlan(SubscriptionPlan plan, List<String> deliveryDays, int quantity);
}

class MockAppRepository implements AppRepository {
  // Simulate delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

  @override
  Future<List<FoodItem>> getFoodItems() async {
    await _delay();
    return DummyData.foodItems;
  }

  @override
  Future<List<Category>> getCategories() async {
    await _delay();
    return DummyData.categories;
  }

  @override
  Future<List<Coupon>> getCoupons() async {
    await _delay();
    return DummyData.coupons;
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    await _delay();
    return DummyData.subscriptionPlans;
  }

  @override
  Future<Order> placeOrder(List<CartItem> items, double discount, Address address) async {
    await _delay();
    double sub = items.fold(0.0, (val, element) => val + element.totalPrice);
    double delivery = 30.0;
    double total = (sub + delivery) - discount;

    final orderItems = items.map((e) => OrderItem(food: e.food, quantity: e.quantity, price: e.food.price)).toList();

    return Order(
      id: 'EAT-${DateTime.now().millisecondsSinceEpoch % 100000}',
      items: orderItems,
      subtotal: sub,
      discount: discount,
      deliveryFee: delivery,
      total: total,
      address: address,
      status: 'Active',
      orderTime: DateTime.now(),
      eta: '35 mins',
    );
  }

  @override
  Future<Subscription> subscribeToPlan(SubscriptionPlan plan, List<String> deliveryDays, int quantity) async {
    await _delay();
    final today = DateTime.now();
    final schedule = List.generate(plan.durationDays, (index) {
      final date = today.add(Duration(days: index + 1));
      return SubscriptionCalendarDay(
        date: date,
        status: 'Upcoming',
        meal: DummyData.foodItems[index % DummyData.foodItems.length],
      );
    });

    return Subscription(
      id: 'SUB-${today.millisecondsSinceEpoch % 100000}',
      plan: plan,
      status: 'Active',
      remainingMeals: plan.totalMeals,
      nextDelivery: today.add(const Duration(days: 1)),
      schedule: schedule,
    );
  }
}
