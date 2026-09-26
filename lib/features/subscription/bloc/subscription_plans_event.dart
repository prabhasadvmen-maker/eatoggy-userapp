import 'package:equatable/equatable.dart';

abstract class SubscriptionPlansEvent extends Equatable {
  const SubscriptionPlansEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubscriptionPlansEvent extends SubscriptionPlansEvent {
  final String? mealType;
  final String? status;

  const FetchSubscriptionPlansEvent({this.mealType, this.status});

  @override
  List<Object?> get props => [mealType, status];
}

class RefreshSubscriptionPlansEvent extends SubscriptionPlansEvent {
  const RefreshSubscriptionPlansEvent();
}
