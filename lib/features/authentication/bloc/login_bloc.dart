import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network_exceptions.dart';
import '../data/models/send_otp_request.dart';
import '../data/models/send_otp_response.dart';
import '../data/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

export 'login_event.dart';
export 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginInitial()) {
    on<LoginSendOtpEvent>(_onSendOtp);
    on<LoginResetEvent>(_onReset);
  }

  Future<void> _onSendOtp(
    LoginSendOtpEvent event,
    Emitter<LoginState> emit,
  ) async {
    final mobile = event.mobile.trim();

    // Business Logic & Validations strictly in BLoC
    if (mobile.isEmpty) {
      emit(const LoginFailure(error: 'Please enter your mobile number'));
      return;
    }

    if (mobile.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      emit(const LoginFailure(error: 'Please enter a valid 10-digit mobile number'));
      return;
    }

    emit(const LoginLoading());

    try {
      final request = SendOtpRequest(mobile: mobile);
      final response = await _authRepository.sendOtp(request);

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      final otpResponse = SendOtpResponse.fromJson(data);

      if (otpResponse.success) {
        emit(LoginOtpSentSuccess(
          message: otpResponse.message.isNotEmpty
              ? otpResponse.message
              : 'OTP sent successfully',
          mobile: mobile,
        ));
      } else {
        emit(LoginFailure(
          error: otpResponse.message.isNotEmpty
              ? otpResponse.message
              : 'Failed to send OTP. Please try again.',
        ));
      }
    } on DioException catch (e) {
      emit(LoginFailure(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  void _onReset(
    LoginResetEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(const LoginInitial());
  }
}
