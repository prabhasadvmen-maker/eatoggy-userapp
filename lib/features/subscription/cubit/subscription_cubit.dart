import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/models/models.dart';
import '../../../core/network/app_repository.dart';

class SubscriptionState extends Equatable {
  final bool isLoading;
  final List<SubscriptionPlan> plans;
  final Subscription? activeSubscription;
  final String? error;

  const SubscriptionState({
    this.isLoading = false,
    this.plans = const [],
    this.activeSubscription,
    this.error,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    List<SubscriptionPlan>? plans,
    Subscription? activeSubscription,
    String? error,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      plans: plans ?? this.plans,
      activeSubscription: activeSubscription ?? this.activeSubscription,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, plans, activeSubscription, error];
}

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final AppRepository repository;

  SubscriptionCubit(this.repository) : super(const SubscriptionState());

  void loadPlans() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final plans = await repository.getSubscriptionPlans();
      emit(state.copyWith(isLoading: false, plans: plans));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to retrieve plans.'));
    }
  }

  void activateSubscription(Subscription sub) {
    emit(state.copyWith(activeSubscription: sub));
  }

  void skipDay(DateTime date) {
    if (state.activeSubscription == null) return;
    final updatedSchedule = state.activeSubscription!.schedule.map((day) {
      if (day.date.year == date.year && day.date.month == date.month && day.date.day == date.day) {
        return day.copyWith(status: 'Skipped');
      }
      return day;
    }).toList();

    emit(state.copyWith(
      activeSubscription: state.activeSubscription!.copyWith(schedule: updatedSchedule),
    ));
  }

  void pauseSubscription() {
    if (state.activeSubscription == null) return;
    emit(state.copyWith(
      activeSubscription: state.activeSubscription!.copyWith(status: 'Paused'),
    ));
  }

  void resumeSubscription() {
    if (state.activeSubscription == null) return;
    emit(state.copyWith(
      activeSubscription: state.activeSubscription!.copyWith(status: 'Active'),
    ));
  }
}
