import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/models/models.dart';
import '../../../core/network/app_repository.dart';
import '../data/models/gourmet_dish_model.dart';
import '../data/repositories/home_repository.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final bool isGourmetLoading;
  final List<FoodItem> featuredMeals;
  final List<Category> categories;
  final List<GourmetDishModel> gourmetCreations;
  final String? error;
  final Address? deliveryAddress;

  const HomeState({
    this.isLoading = false,
    this.isGourmetLoading = false,
    this.featuredMeals = const [],
    this.categories = const [],
    this.gourmetCreations = const [],
    this.error,
    this.deliveryAddress,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isGourmetLoading,
    List<FoodItem>? featuredMeals,
    List<Category>? categories,
    List<GourmetDishModel>? gourmetCreations,
    String? error,
    Address? deliveryAddress,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isGourmetLoading: isGourmetLoading ?? this.isGourmetLoading,
      featuredMeals: featuredMeals ?? this.featuredMeals,
      categories: categories ?? this.categories,
      gourmetCreations: gourmetCreations ?? this.gourmetCreations,
      error: error ?? this.error,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isGourmetLoading,
        featuredMeals,
        categories,
        gourmetCreations,
        error,
        deliveryAddress,
      ];
}

class HomeCubit extends Cubit<HomeState> {
  final AppRepository repository;
  final HomeRepository homeRepository;

  HomeCubit(
    this.repository, {
    HomeRepository? homeRepository,
  })  : homeRepository = homeRepository ?? HomeRepositoryImpl(),
        super(const HomeState());

  Future<void> loadDashboard() async {
    final gourmetFuture = loadGourmetCreations();

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
      await gourmetFuture;
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
    await gourmetFuture;
  }

  Future<void> loadGourmetCreations() async {
    emit(state.copyWith(isGourmetLoading: true));
    try {
      final response = await homeRepository.getGourmetDishes();

      final Map<String, dynamic> responseData =
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : (response.data is Map
                  ? Map<String, dynamic>.from(response.data as Map)
                  : <String, dynamic>{});

      final gourmetResponse = GetGourmetDishesResponse.fromJson(responseData);

      if (gourmetResponse.success) {
        emit(state.copyWith(
          isGourmetLoading: false,
          gourmetCreations: gourmetResponse.data,
        ));
      } else {
        emit(state.copyWith(isGourmetLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isGourmetLoading: false));
    }
  }

  void updateAddress(Address address) {
    emit(state.copyWith(deliveryAddress: address));
  }
}
