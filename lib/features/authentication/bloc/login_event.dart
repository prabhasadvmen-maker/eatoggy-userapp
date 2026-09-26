import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSendOtpEvent extends LoginEvent {
  final String mobile;

  const LoginSendOtpEvent({required this.mobile});

  @override
  List<Object?> get props => [mobile];
}

class LoginResetEvent extends LoginEvent {
  const LoginResetEvent();
}
