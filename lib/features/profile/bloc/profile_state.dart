import 'package:equatable/equatable.dart';
import '../data/models/get_profile_response.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileCustomer customer;
  final String message;

  const ProfileLoaded({
    required this.customer,
    required this.message,
  });

  @override
  List<Object?> get props => [customer, message];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
