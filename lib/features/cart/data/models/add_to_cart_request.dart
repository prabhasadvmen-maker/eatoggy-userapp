class AddToCartRequest {
  final String menuItemId;
  final int quantity;

  AddToCartRequest({
    required this.menuItemId,
    int quantity = 1,
  }) : quantity = quantity < 1 ? 1 : quantity;

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'quantity': quantity < 1 ? 1 : quantity,
    };
  }

  factory AddToCartRequest.fromJson(Map<String, dynamic> json) {
    final rawQty = (json['quantity'] as num?)?.toInt() ?? 1;
    return AddToCartRequest(
      menuItemId: json['menuItemId'] as String? ?? '',
      quantity: rawQty < 1 ? 1 : rawQty,
    );
  }
}
