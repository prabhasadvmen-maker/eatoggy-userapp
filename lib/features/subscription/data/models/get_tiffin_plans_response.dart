import '../../../../shared/models/models.dart';

class TiffinMealItem {
  final String name;
  final int quantity;

  const TiffinMealItem({
    required this.name,
    required this.quantity,
  });

  factory TiffinMealItem.fromJson(Map<String, dynamic> json) {
    return TiffinMealItem(
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}

class TiffinRestaurantRef {
  final String id;

  const TiffinRestaurantRef({required this.id});

  factory TiffinRestaurantRef.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return TiffinRestaurantRef(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
      );
    } else if (json is Map) {
      return TiffinRestaurantRef(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      );
    } else if (json is String) {
      return TiffinRestaurantRef(id: json);
    }
    return const TiffinRestaurantRef(id: '');
  }

  Map<String, dynamic> toJson() {
    return {'_id': id};
  }
}

class TiffinPlanModel {
  final String id;
  final TiffinRestaurantRef? restaurantId;
  final String name;
  final String description;
  final String image;
  final String mealType;
  final List<TiffinMealItem> items;
  final double pricePerMeal;
  final int planDurationDays;
  final int totalMeals;
  final double totalPrice;
  final List<String> availableDays;
  final String status;
  final int sortOrder;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  const TiffinPlanModel({
    required this.id,
    this.restaurantId,
    required this.name,
    required this.description,
    required this.image,
    required this.mealType,
    required this.items,
    required this.pricePerMeal,
    required this.planDurationDays,
    required this.totalMeals,
    required this.totalPrice,
    required this.availableDays,
    required this.status,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TiffinPlanModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    List<TiffinMealItem> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems
          .map((item) {
            if (item is Map<String, dynamic>) {
              return TiffinMealItem.fromJson(item);
            } else if (item is Map) {
              return TiffinMealItem.fromJson(Map<String, dynamic>.from(item));
            }
            return null;
          })
          .whereType<TiffinMealItem>()
          .toList();
    }

    final rawDays = json['availableDays'];
    List<String> parsedDays = [];
    if (rawDays is List) {
      parsedDays = rawDays.map((e) => e.toString()).toList();
    }

    return TiffinPlanModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      restaurantId: json['restaurantId'] != null
          ? TiffinRestaurantRef.fromJson(json['restaurantId'])
          : null,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      mealType: json['mealType'] as String? ?? 'LUNCH',
      items: parsedItems,
      pricePerMeal: (json['pricePerMeal'] as num?)?.toDouble() ?? 0.0,
      planDurationDays: (json['planDurationDays'] as num?)?.toInt() ?? 0,
      totalMeals: (json['totalMeals'] as num?)?.toInt() ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      availableDays: parsedDays,
      status: json['status'] as String? ?? 'ACTIVE',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['__v'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'restaurantId': restaurantId?.toJson(),
      'name': name,
      'description': description,
      'image': image,
      'mealType': mealType,
      'items': items.map((i) => i.toJson()).toList(),
      'pricePerMeal': pricePerMeal,
      'planDurationDays': planDurationDays,
      'totalMeals': totalMeals,
      'totalPrice': totalPrice,
      'availableDays': availableDays,
      'status': status,
      'sortOrder': sortOrder,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  /// Converts to the shared [SubscriptionPlan] entity for interoperability
  /// with subsequent screens (e.g., plan_detail, customize_subscription).
  SubscriptionPlan toSubscriptionPlan() {
    final benefits = items.isNotEmpty
        ? items.map((item) => '${item.quantity}x ${item.name}').toList()
        : (description.isNotEmpty ? [description] : ['Daily healthy meal']);

    return SubscriptionPlan(
      id: id,
      name: name,
      pricePerMeal: pricePerMeal,
      totalMeals: totalMeals,
      durationDays: planDurationDays,
      deliveryDays: availableDays,
      benefits: benefits,
      isRecommended: planDurationDays >= 14,
    );
  }
}

class TiffinPlansData {
  final List<TiffinPlanModel> plans;

  const TiffinPlansData({
    required this.plans,
  });

  factory TiffinPlansData.fromJson(Map<String, dynamic> json) {
    final rawPlans = json['plans'];
    List<TiffinPlanModel> parsedPlans = [];
    if (rawPlans is List) {
      parsedPlans = rawPlans
          .map((plan) {
            if (plan is Map<String, dynamic>) {
              return TiffinPlanModel.fromJson(plan);
            } else if (plan is Map) {
              return TiffinPlanModel.fromJson(Map<String, dynamic>.from(plan));
            }
            return null;
          })
          .whereType<TiffinPlanModel>()
          .toList();
    }

    return TiffinPlansData(plans: parsedPlans);
  }

  Map<String, dynamic> toJson() {
    return {
      'plans': plans.map((p) => p.toJson()).toList(),
    };
  }
}

class GetTiffinPlansResponse {
  final bool success;
  final String message;
  final TiffinPlansData? data;

  const GetTiffinPlansResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory GetTiffinPlansResponse.fromJson(Map<String, dynamic> json) {
    return GetTiffinPlansResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] is Map<String, dynamic>
          ? TiffinPlansData.fromJson(json['data'] as Map<String, dynamic>)
          : (json['data'] is Map
              ? TiffinPlansData.fromJson(
                  Map<String, dynamic>.from(json['data'] as Map),
                )
              : null),
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
