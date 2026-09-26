import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginOtpSentSuccess extends LoginState {
  final String message;
  final String mobile;

  const LoginOtpSentSuccess({
    required this.message,
    required this.mobile,
  });

  @override
  List<Object?> get props => [message, mobile];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
