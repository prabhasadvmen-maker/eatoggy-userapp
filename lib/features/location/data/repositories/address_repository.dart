import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/add_address_request.dart';

abstract class AddressRepository {
  Future<Response> addAddress(AddAddressRequest request);
}

class AddressRepositoryImpl implements AddressRepository {
  @override
  Future<Response> addAddress(AddAddressRequest request) {
    return ApiService.dio.post(
      ApiConstants.customerAddresses,
      data: request.toJson(),
    );
  }
}
