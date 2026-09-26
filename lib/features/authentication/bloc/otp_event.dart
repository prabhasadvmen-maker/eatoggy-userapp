import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class VerifyOtpSubmitEvent extends OtpEvent {
  final String mobile;
  final String otp;

  const VerifyOtpSubmitEvent({
    required this.mobile,
    required this.otp,
  });

  @override
  List<Object?> get props => [mobile, otp];
}

class ResendOtpEvent extends OtpEvent {
  final String mobile;

  const ResendOtpEvent({
    required this.mobile,
  });

  @override
  List<Object?> get props => [mobile];
}
