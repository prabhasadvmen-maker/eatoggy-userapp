import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/get_profile_request.dart';

abstract class ProfileRepository {
  Future<Response> getProfile({GetProfileRequest? request});
}

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Response> getProfile({GetProfileRequest? request}) {
    return ApiService.dio.get(ApiConstants.customerProfile);
  }
}
