class UpdateCartItemRequest {
  final int quantity;

  UpdateCartItemRequest({
    required int quantity,
  }) : quantity = quantity < 1 ? 1 : quantity;

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity < 1 ? 1 : quantity,
    };
  }

  factory UpdateCartItemRequest.fromJson(Map<String, dynamic> json) {
    final rawQty = (json['quantity'] as num?)?.toInt() ?? 1;
    return UpdateCartItemRequest(
      quantity: rawQty < 1 ? 1 : rawQty,
    );
  }
}
