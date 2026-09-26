import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final bool isVeg;
  final String nutrition;
  final List<String> ingredients;
  final bool isAvailable;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.isVeg,
    required this.nutrition,
    required this.ingredients,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, category, rating, isVeg, nutrition, ingredients, isAvailable];
}

class Category extends Equatable {
  final String id;
  final String name;
  final String icon;

  const Category({required this.id, required this.name, required this.icon});

  @override
  List<Object?> get props => [id, name, icon];
}

class Address extends Equatable {
  final String id;
  final String name;
  final String flatHouse;
  final String street;
  final String landmark;
  final String city;
  final String pincode;
  final String type; // Home, Work, Other

  const Address({
    required this.id,
    required this.name,
    required this.flatHouse,
    required this.street,
    required this.landmark,
    required this.city,
    required this.pincode,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, flatHouse, street, landmark, city, pincode, type];
}

class CartItem extends Equatable {
  final String? cartItemId;
  final FoodItem food;
  final int quantity;
  final List<String> addOns;

  const CartItem({
    this.cartItemId,
    required this.food,
    this.quantity = 1,
    this.addOns = const [],
  });

  CartItem copyWith({String? cartItemId, FoodItem? food, int? quantity, List<String>? addOns}) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      addOns: addOns ?? this.addOns,
    );
  }

  double get totalPrice => food.price * quantity;

  @override
  List<Object?> get props => [cartItemId, food, quantity, addOns];
}

class Coupon extends Equatable {
  final String code;
  final double discountPercent;
  final double maxDiscount;
  final double minOrderValue;
  final String description;
  final String expiryDate;

  const Coupon({
    required this.code,
    required this.discountPercent,
    required this.maxDiscount,
    required this.minOrderValue,
    required this.description,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [code, discountPercent, maxDiscount, minOrderValue, description, expiryDate];
}

class SubscriptionPlan extends Equatable {
  final String id;
  final String name;
  final double pricePerMeal;
  final int totalMeals;
  final int durationDays;
  final List<String> deliveryDays;
  final List<String> benefits;
  final bool isRecommended;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.pricePerMeal,
    required this.totalMeals,
    required this.durationDays,
    required this.deliveryDays,
    required this.benefits,
    this.isRecommended = false,
  });

  double get totalPlanPrice => pricePerMeal * totalMeals;

  @override
  List<Object?> get props => [id, name, pricePerMeal, totalMeals, durationDays, deliveryDays, benefits, isRecommended];
}

class SubscriptionCalendarDay extends Equatable {
  final DateTime date;
  final String status; // Upcoming, Delivered, Skipped, Paused
  final FoodItem? meal;

  const SubscriptionCalendarDay({
    required this.date,
    required this.status,
    this.meal,
  });

  SubscriptionCalendarDay copyWith({DateTime? date, String? status, FoodItem? meal}) {
    return SubscriptionCalendarDay(
      date: date ?? this.date,
      status: status ?? this.status,
      meal: meal ?? this.meal,
    );
  }

  @override
  List<Object?> get props => [date, status, meal];
}

class Subscription extends Equatable {
  final String id;
  final SubscriptionPlan plan;
  final String status; // Active, Paused, Expired, Cancelled
  final int remainingMeals;
  final DateTime nextDelivery;
  final List<SubscriptionCalendarDay> schedule;

  const Subscription({
    required this.id,
    required this.plan,
    required this.status,
    required this.remainingMeals,
    required this.nextDelivery,
    required this.schedule,
  });

  Subscription copyWith({
    String? id,
    SubscriptionPlan? plan,
    String? status,
    int? remainingMeals,
    DateTime? nextDelivery,
    List<SubscriptionCalendarDay>? schedule,
  }) {
    return Subscription(
      id: id ?? this.id,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      remainingMeals: remainingMeals ?? this.remainingMeals,
      nextDelivery: nextDelivery ?? this.nextDelivery,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  List<Object?> get props => [id, plan, status, remainingMeals, nextDelivery, schedule];
}

class OrderItem extends Equatable {
  final FoodItem food;
  final int quantity;
  final double price;

  const OrderItem({required this.food, required this.quantity, required this.price});

  @override
  List<Object?> get props => [food, quantity, price];
}

class Order extends Equatable {
  final String id;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final Address address;
  final String status; // Active, Delivered, Cancelled, Refunded
  final DateTime orderTime;
  final String eta;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.address,
    required this.status,
    required this.orderTime,
    required this.eta,
  });

  Order copyWith({String? status}) {
    return Order(
      id: id,
      items: items,
      subtotal: subtotal,
      discount: discount,
      deliveryFee: deliveryFee,
      total: total,
      address: address,
      status: status ?? this.status,
      orderTime: orderTime,
      eta: eta,
    );
  }

  @override
  List<Object?> get props => [id, items, subtotal, discount, deliveryFee, total, address, status, orderTime, eta];
}

class SupportTicket extends Equatable {
  final String id;
  final String issue;
  final String status; // Open, Pending, Resolved
  final DateTime createdAt;
  final List<Map<String, dynamic>> messages;

  const SupportTicket({
    required this.id,
    required this.issue,
    required this.status,
    required this.createdAt,
    required this.messages,
  });

  @override
  List<Object?> get props => [id, issue, status, createdAt, messages];
}

class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category; // Orders, Subscription, Offers, System
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      description: description,
      category: category,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, description, category, timestamp, isRead];
}
