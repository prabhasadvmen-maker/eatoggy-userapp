import '../../../../shared/models/models.dart';

class GourmetRestaurantRef {
  final String id;

  const GourmetRestaurantRef({required this.id});

  factory GourmetRestaurantRef.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return GourmetRestaurantRef(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
      );
    } else if (json is Map) {
      return GourmetRestaurantRef(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      );
    } else if (json is String) {
      return GourmetRestaurantRef(id: json);
    }
    return const GourmetRestaurantRef(id: '');
  }

  Map<String, dynamic> toJson() {
    return {'_id': id};
  }
}

class GourmetDishModel {
  final String id;
  final GourmetRestaurantRef? restaurantId;
  final String name;
  final String description;
  final String? image;
  final double price;
  final String foodType;
  final int? preparationTime;

  const GourmetDishModel({
    required this.id,
    this.restaurantId,
    required this.name,
    required this.description,
    this.image,
    required this.price,
    required this.foodType,
    this.preparationTime,
  });

  bool get isVeg => foodType.toUpperCase() != 'NON_VEG';

  factory GourmetDishModel.fromJson(Map<String, dynamic> json) {
    return GourmetDishModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      restaurantId: json['restaurantId'] != null
          ? GourmetRestaurantRef.fromJson(json['restaurantId'])
          : null,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      foodType: json['foodType'] as String? ?? 'VEG',
      preparationTime: (json['preparationTime'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'restaurantId': restaurantId?.toJson(),
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'foodType': foodType,
      if (preparationTime != null) 'preparationTime': preparationTime,
    };
  }
  FoodItem toFoodItem() {
    final fallbackAsset = isVeg ? 'assets/f1.png' : 'assets/f2.png';
    final effectiveImageUrl =
        (image != null && image!.trim().isNotEmpty) ? image!.trim() : fallbackAsset;

    return FoodItem(
      id: id,
      name: name,
      description: description.isNotEmpty
          ? description
          : (isVeg
              ? 'Exquisite chef crafted vegetarian preparation'
              : 'Slow cooked aromatic Mughlai gourmet delicacy'),
      price: price,
      imageUrl: effectiveImageUrl,
      category: 'Gourmet Creations',
      rating: 4.9,
      isVeg: isVeg,
      nutrition: preparationTime != null
          ? 'Prep: ${preparationTime}m | Chef Curated'
          : 'Chef Special Curated Dish',
      ingredients: isVeg
          ? const ['Fresh Cottage Cheese', 'Cashew Paste', 'Gourmet Spices', 'Herbs']
          : const ['Tender Chicken/Mutton', 'Aromatic Gravy', 'Exotic Spices'],
      isAvailable: true,
    );
  }
}

class GetGourmetDishesResponse {
  final bool success;
  final String? message;
  final List<GourmetDishModel> data;

  const GetGourmetDishesResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory GetGourmetDishesResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<GourmetDishModel> parsedList = [];

    if (rawData is List) {
      parsedList = rawData
          .map((item) {
            if (item is Map<String, dynamic>) {
              return GourmetDishModel.fromJson(item);
            } else if (item is Map) {
              return GourmetDishModel.fromJson(
                Map<String, dynamic>.from(item),
              );
            }
            return null;
          })
          .whereType<GourmetDishModel>()
          .toList();
    }

    return GetGourmetDishesResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: parsedList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((d) => d.toJson()).toList(),
    };
  }
}
