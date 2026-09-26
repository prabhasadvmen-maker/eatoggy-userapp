import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/get_tiffin_plans_request.dart';

abstract class SubscriptionRepository {
  Future<Response> getTiffinPlans({GetTiffinPlansRequest? request});
}

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  @override
  Future<Response> getTiffinPlans({GetTiffinPlansRequest? request}) {
    final queryParams = request?.toJson();
    return ApiService.dio.get(
      ApiConstants.tiffinPlans,
      queryParameters: (queryParams != null && queryParams.isNotEmpty)
          ? queryParams
          : null,
    );
  }
}
