import '../../../../shared/models/models.dart';

class CartRestaurantModel {
  final String id;
  final String? image;

  const CartRestaurantModel({
    required this.id,
    this.image,
  });

  factory CartRestaurantModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return CartRestaurantModel(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        image: json['image'] as String?,
      );
    } else if (json is Map) {
      return CartRestaurantModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        image: json['image']?.toString(),
      );
    } else if (json is String) {
      return CartRestaurantModel(id: json);
    }
    return const CartRestaurantModel(id: '');
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': image,
    };
  }
}

class CartApiItemModel {
  final String id;
  final String menuItemId;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final double itemSubtotal;

  const CartApiItemModel({
    required this.id,
    required this.menuItemId,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    required this.itemSubtotal,
  });

  factory CartApiItemModel.fromJson(Map<String, dynamic> json) {
    return CartApiItemModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      menuItemId: json['menuItemId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      itemSubtotal: (json['itemSubtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'menuItemId': menuItemId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'itemSubtotal': itemSubtotal,
    };
  }

  CartItem toCartItem() {
    final isVegDish = !name.toLowerCase().contains('chicken') &&
        !name.toLowerCase().contains('mutton') &&
        !name.toLowerCase().contains('meat') &&
        !name.toLowerCase().contains('fish') &&
        !name.toLowerCase().contains('egg');
    final fallbackAsset = isVegDish ? 'assets/f1.png' : 'assets/f2.png';
    final effectiveImage =
        (image != null && image!.trim().isNotEmpty) ? image!.trim() : fallbackAsset;

    return CartItem(
      cartItemId: id,
      food: FoodItem(
        id: menuItemId.isNotEmpty ? menuItemId : id,
        name: name,
        description: 'Chef special gourmet creation',
        price: price,
        imageUrl: effectiveImage,
        category: 'Gourmet',
        rating: 4.8,
        isVeg: isVegDish,
        nutrition: 'Chef Curated',
        ingredients: const ['Fresh Ingredients', 'Aromatic Spices'],
        isAvailable: true,
      ),
      quantity: quantity < 1 ? 1 : quantity,
    );
  }
}

class CartDataModel {
  final String id;
  final String customerId;
  final String? restaurantId;
  final CartRestaurantModel? restaurant;
  final List<CartApiItemModel> items;
  final double subtotal;
  final String? updatedAt;

  const CartDataModel({
    required this.id,
    required this.customerId,
    this.restaurantId,
    this.restaurant,
    required this.items,
    required this.subtotal,
    this.updatedAt,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    List<CartApiItemModel> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems
          .map((item) {
            if (item is Map<String, dynamic>) {
              return CartApiItemModel.fromJson(item);
            } else if (item is Map) {
              return CartApiItemModel.fromJson(Map<String, dynamic>.from(item));
            }
            return null;
          })
          .whereType<CartApiItemModel>()
          .toList();
    }

    return CartDataModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      restaurantId: json['restaurantId'] as String?,
      restaurant: json['restaurant'] != null
          ? CartRestaurantModel.fromJson(json['restaurant'])
          : null,
      items: parsedItems,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customerId': customerId,
      'restaurantId': restaurantId,
      'restaurant': restaurant?.toJson(),
      'items': items.map((i) => i.toJson()).toList(),
      'subtotal': subtotal,
      'updatedAt': updatedAt,
    };
  }
}

class AddToCartResponse {
  final bool success;
  final String? message;
  final CartDataModel? data;

  const AddToCartResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
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
