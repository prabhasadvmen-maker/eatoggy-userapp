import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/services/storage_service.dart';
import '../data/models/delete_address_response.dart';
import '../data/models/get_addresses_response.dart';
import '../data/repositories/get_addresses_repository.dart';
import 'saved_addresses_event.dart';
import 'saved_addresses_state.dart';

class SavedAddressesBloc
    extends Bloc<SavedAddressesEvent, SavedAddressesState> {
  final GetAddressesRepository _getAddressesRepository;

  SavedAddressesBloc({GetAddressesRepository? getAddressesRepository})
      : _getAddressesRepository =
            getAddressesRepository ?? GetAddressesRepositoryImpl(),
        super(const SavedAddressesInitial()) {
    on<FetchSavedAddressesEvent>(_onFetchSavedAddresses);
    on<SelectActiveAddressEvent>(_onSelectActiveAddress);
    on<DeleteSavedAddressEvent>(_onDeleteAddress);
  }

  Future<void> _onFetchSavedAddresses(
    FetchSavedAddressesEvent event,
    Emitter<SavedAddressesState> emit,
  ) async {
    emit(const SavedAddressesLoading());

    try {
      final response = await _getAddressesRepository.getAddresses();

      final Map<String, dynamic> responseData =
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : (response.data is Map
                  ? Map<String, dynamic>.from(response.data as Map)
                  : <String, dynamic>{});

      final addressesResponse = GetAddressesResponse.fromJson(responseData);

      if (addressesResponse.success) {
        if (addressesResponse.data.isEmpty) {
          emit(const SavedAddressesEmpty());
        } else {
          // Identify if any is default
          String? defaultId;
          for (final a in addressesResponse.data) {
            if (a.isDefault) {
              defaultId = a.id;
              break;
            }
          }
          defaultId ??= addressesResponse.data.first.id;

          emit(SavedAddressesLoaded(
            addresses: addressesResponse.data,
            activeAddressId: defaultId,
          ));
        }
      } else {
        emit(SavedAddressesFailure(
          error: addressesResponse.message.isNotEmpty
              ? addressesResponse.message
              : 'Failed to fetch addresses',
        ));
      }
    } on DioException catch (dioError) {
      String errorMessage = 'Failed to load addresses.';
      if (dioError.response?.data is Map &&
          dioError.response?.data['message'] != null) {
        errorMessage = dioError.response!.data['message'].toString();
      } else {
        errorMessage = NetworkExceptions.getErrorMessage(dioError);
      }
      emit(SavedAddressesFailure(error: errorMessage));
    } catch (e) {
      emit(SavedAddressesFailure(error: e.toString()));
    }
  }

  Future<void> _onSelectActiveAddress(
    SelectActiveAddressEvent event,
    Emitter<SavedAddressesState> emit,
  ) async {
    final prefs = await SharedPreferencesService.getInstance();
    final fullAddress =
        '${event.address.addressLine1}, ${event.address.addressLine2}, ${event.address.city}';
    await prefs.setString(AppKeys.currentAddress, fullAddress);

    if (state is SavedAddressesLoaded) {
      final currentList = (state as SavedAddressesLoaded).addresses;
      emit(SavedAddressesLoaded(
        addresses: currentList,
        activeAddressId: event.address.id,
      ));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteSavedAddressEvent event,
    Emitter<SavedAddressesState> emit,
  ) async {
    try {
      final response =
          await _getAddressesRepository.deleteAddress(event.addressId);

      final Map<String, dynamic> responseData =
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : (response.data is Map
                  ? Map<String, dynamic>.from(response.data as Map)
                  : <String, dynamic>{});

      final deleteResponse = DeleteAddressResponse.fromJson(responseData);

      if (deleteResponse.success) {
        emit(AddressDeleteSuccess(
          message: deleteResponse.message.isNotEmpty
              ? deleteResponse.message
              : 'Address deleted successfully',
        ));
        add(const FetchSavedAddressesEvent());
      } else {
        emit(SavedAddressesFailure(
          error: deleteResponse.message.isNotEmpty
              ? deleteResponse.message
              : 'Failed to delete address',
        ));
      }
    } on DioException catch (dioError) {
      String errorMessage = 'Failed to delete address.';
      if (dioError.response?.data is Map &&
          dioError.response?.data['message'] != null) {
        errorMessage = dioError.response!.data['message'].toString();
      } else {
        errorMessage = NetworkExceptions.getErrorMessage(dioError);
      }
      emit(SavedAddressesFailure(error: errorMessage));
    } catch (e) {
      emit(SavedAddressesFailure(error: e.toString()));
    }
  }
}
