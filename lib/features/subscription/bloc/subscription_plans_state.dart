import 'package:equatable/equatable.dart';
import '../data/models/get_tiffin_plans_response.dart';

abstract class SubscriptionPlansState extends Equatable {
  const SubscriptionPlansState();

  @override
  List<Object?> get props => [];
}

class SubscriptionPlansInitial extends SubscriptionPlansState {
  const SubscriptionPlansInitial();
}

class SubscriptionPlansLoading extends SubscriptionPlansState {
  const SubscriptionPlansLoading();
}

class SubscriptionPlansLoaded extends SubscriptionPlansState {
  final List<TiffinPlanModel> plans;
  final String message;

  const SubscriptionPlansLoaded({
    required this.plans,
    required this.message,
  });

  @override
  List<Object?> get props => [plans, message];
}

class SubscriptionPlansFailure extends SubscriptionPlansState {
  final String error;

  const SubscriptionPlansFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
