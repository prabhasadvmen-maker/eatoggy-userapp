import 'package:equatable/equatable.dart';
import '../../../shared/models/models.dart';

class MenuState extends Equatable {
  final bool isLoading;
  final List<String> categories;
  final String selectedCategory;
  final List<FoodItem> meals;
  final String? error;

  const MenuState({
    this.isLoading = false,
    this.categories = const [
      'Royal Thali',
      'Luxe Curries',
      'Heritage Breads',
      'Desserts'
    ],
    this.selectedCategory = 'Royal Thali',
    this.meals = const [],
    this.error,
  });

  MenuState copyWith({
    bool? isLoading,
    List<String>? categories,
    String? selectedCategory,
    List<FoodItem>? meals,
    String? error,
  }) {
    return MenuState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      meals: meals ?? this.meals,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, categories, selectedCategory, meals, error];
}
