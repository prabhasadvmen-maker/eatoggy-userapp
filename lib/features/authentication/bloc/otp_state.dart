import 'package:equatable/equatable.dart';
import '../data/models/verify_otp_response.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {
  const OtpInitial();
}

class OtpLoading extends OtpState {
  const OtpLoading();
}

class OtpVerificationSuccess extends OtpState {
  final String message;
  final VerifyOtpResponse response;

  const OtpVerificationSuccess({
    required this.message,
    required this.response,
  });

  @override
  List<Object?> get props => [message, response];
}

class OtpResentSuccess extends OtpState {
  final String message;

  const OtpResentSuccess({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class OtpFailure extends OtpState {
  final String error;

  const OtpFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
