import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/models/models.dart';
import '../../../core/network/app_repository.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<FoodItem> featuredMeals;
  final List<Category> categories;
  final String? error;
  final Address? deliveryAddress;

  const HomeState({
    this.isLoading = false,
    this.featuredMeals = const [],
    this.categories = const [],
    this.error,
    this.deliveryAddress,
  });

  HomeState copyWith({
    bool? isLoading,
    List<FoodItem>? featuredMeals,
    List<Category>? categories,
    String? error,
    Address? deliveryAddress,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      featuredMeals: featuredMeals ?? this.featuredMeals,
      categories: categories ?? this.categories,
      error: error ?? this.error,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }

  @override
  List<Object?> get props => [isLoading, featuredMeals, categories, error, deliveryAddress];
}

class HomeCubit extends Cubit<HomeState> {
  final AppRepository repository;

  HomeCubit(this.repository) : super(const HomeState());

  void loadDashboard() async {
    // If dashboard data is already loaded, refresh silently in the background
    // to prevent showing a blocking loader on every tab navigation.
    if (state.featuredMeals.isNotEmpty && state.categories.isNotEmpty) {
      try {
        final results = await Future.wait([
          repository.getFoodItems(),
          repository.getCategories(),
        ]);
        emit(state.copyWith(
          featuredMeals: results[0] as List<FoodItem>,
          categories: results[1] as List<Category>,
        ));
      } catch (_) {}
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Execute repository calls in parallel using Future.wait to cut loading delay in half
      final results = await Future.wait([
        repository.getFoodItems(),
        repository.getCategories(),
      ]);
      
      emit(state.copyWith(
        isLoading: false,
        featuredMeals: results[0] as List<FoodItem>,
        categories: results[1] as List<Category>,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load Dashboard data.'));
    }
  }

  void updateAddress(Address address) {
    emit(state.copyWith(deliveryAddress: address));
  }
}
