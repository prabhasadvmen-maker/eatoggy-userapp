import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/send_otp_request.dart';
import '../models/verify_otp_request.dart';

abstract class AuthRepository {
  Future<Response> sendOtp(SendOtpRequest request);
  Future<Response> verifyOtp(VerifyOtpRequest request);
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Response> sendOtp(SendOtpRequest request) {
    return ApiService.dio.post(
      ApiConstants.sendOtp,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> verifyOtp(VerifyOtpRequest request) {
    return ApiService.dio.post(
      ApiConstants.verifyOtp,
      data: request.toJson(),
    );
  }
}
