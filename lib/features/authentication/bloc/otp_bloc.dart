import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/network_exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../data/models/send_otp_request.dart';
import '../data/models/send_otp_response.dart';
import '../data/models/verify_otp_request.dart';
import '../data/models/verify_otp_response.dart';
import '../data/repositories/auth_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

export 'otp_event.dart';
export 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthRepository _authRepository;

  OtpBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const OtpInitial()) {
    on<VerifyOtpSubmitEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
  }

  Future<void> _onVerifyOtp(
    VerifyOtpSubmitEvent event,
    Emitter<OtpState> emit,
  ) async {
    final otp = event.otp.trim();
    final mobile = event.mobile.trim();

    // Business Logic & Validations strictly in BLoC (No UI logic)
    if (otp.isEmpty) {
      emit(const OtpFailure(error: 'Please enter verification code'));
      return;
    }

    if (otp.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(otp)) {
      emit(const OtpFailure(error: 'Please enter a valid 6-digit verification code'));
      return;
    }

    emit(const OtpLoading());

    try {
      final request = VerifyOtpRequest(mobile: mobile, otp: otp);
      final response = await _authRepository.verifyOtp(request);

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      final verifyResponse = VerifyOtpResponse.fromJson(data);

      if (verifyResponse.success) {
        // Save Bearer token to SharedPreferences
        final token = verifyResponse.data?.token;
        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferencesService.getInstance();
          await prefs.setString(AppKeys.accessToken, token);
        }

        emit(OtpVerificationSuccess(
          message: verifyResponse.message.isNotEmpty
              ? verifyResponse.message
              : 'Mobile verified successfully',
          response: verifyResponse,
        ));
      } else {
        emit(OtpFailure(
          error: verifyResponse.message.isNotEmpty
              ? verifyResponse.message
              : 'Verification failed. Please check OTP.',
        ));
      }
    } on DioException catch (e) {
      emit(OtpFailure(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(OtpFailure(error: e.toString()));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<OtpState> emit,
  ) async {
    final mobile = event.mobile.trim();

    if (mobile.isEmpty) {
      emit(const OtpFailure(error: 'Invalid mobile number'));
      return;
    }

    emit(const OtpLoading());

    try {
      final request = SendOtpRequest(mobile: mobile);
      final response = await _authRepository.sendOtp(request);

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      final otpResponse = SendOtpResponse.fromJson(data);

      if (otpResponse.success) {
        emit(OtpResentSuccess(
          message: otpResponse.message.isNotEmpty
              ? otpResponse.message
              : 'OTP resent successfully',
        ));
      } else {
        emit(OtpFailure(
          error: otpResponse.message.isNotEmpty
              ? otpResponse.message
              : 'Failed to resend OTP. Please try again.',
        ));
      }
    } on DioException catch (e) {
      emit(OtpFailure(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(OtpFailure(error: e.toString()));
    }
  }
}
