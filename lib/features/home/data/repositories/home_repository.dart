import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';

abstract class HomeRepository {
  Future<Response> getGourmetDishes();
}

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<Response> getGourmetDishes() {
    return ApiService.dio.get(ApiConstants.discoveryGourmet);
  }
}
