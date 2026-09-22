import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/models/models.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(const MenuState()) {
    loadMenu();
  }

  // Static mockup meals matching design spec
  static const List<FoodItem> _allMockMenuMeals = [
    FoodItem(
      id: 'm1_mock',
      name: 'Dal Makhani Heritage',
      description: 'Slow simmered for 24 hours with organic spices and rich cream.',
      price: 289.0,
      imageUrl: 'assets/f1.png',
      category: 'Royal Thali',
      rating: 4.8,
      isVeg: true,
      nutrition: 'Calories: 450 kcal | Protein: 14g | Carbs: 52g | Fat: 18g',
      ingredients: ['Black Lentils', 'Butter', 'Cream', 'Spices'],
    ),
    FoodItem(
      id: 'm2_mock',
      name: 'Kesari Pulao',
      description: 'Aromatic basmati rice steeped in rich saffron, dry fruits, and spices.',
      price: 229.0,
      imageUrl: 'assets/f2.png',
      category: 'Royal Thali',
      rating: 4.7,
      isVeg: true,
      nutrition: 'Calories: 380 kcal | Protein: 8g | Carbs: 65g | Fat: 10g',
      ingredients: ['Basmati Rice', 'Saffron', 'Cashews', 'Raisins', 'Ghee'],
    ),
  ];

  void loadMenu() {
    final filtered = _allMockMenuMeals
        .where((item) => item.category == state.selectedCategory)
        .toList();
    emit(state.copyWith(meals: filtered));
  }

  void selectCategory(String category) {
    final filtered = _allMockMenuMeals
        .where((item) => item.category == category)
        .toList();
    emit(state.copyWith(selectedCategory: category, meals: filtered));
  }
}
