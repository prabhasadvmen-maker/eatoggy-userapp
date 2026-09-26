class GetTiffinPlansRequest {
  final String? mealType;
  final String? status;

  const GetTiffinPlansRequest({
    this.mealType,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (mealType != null && mealType!.isNotEmpty) {
      map['mealType'] = mealType;
    }
    if (status != null && status!.isNotEmpty) {
      map['status'] = status;
    }
    return map;
  }
}
