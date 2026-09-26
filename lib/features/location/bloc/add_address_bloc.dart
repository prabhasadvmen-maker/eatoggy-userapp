import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/services/storage_service.dart';
import '../data/models/add_address_request.dart';
import '../data/models/add_address_response.dart';
import '../data/repositories/address_repository.dart';
import 'add_address_event.dart';
import 'add_address_state.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  final AddressRepository _addressRepository;

  AddAddressBloc({AddressRepository? addressRepository})
      : _addressRepository = addressRepository ?? AddressRepositoryImpl(),
        super(const AddAddressInitial()) {
    on<AddressTypeChangedEvent>(_onAddressTypeChanged);
    on<AddressDefaultToggledEvent>(_onAddressDefaultToggled);
    on<SubmitAddressEvent>(_onSubmitAddress);
  }

  void _onAddressTypeChanged(
    AddressTypeChangedEvent event,
    Emitter<AddAddressState> emit,
  ) {
    emit(AddAddressInitial(
      selectedLabel: event.label,
      isDefault: state.isDefault,
    ));
  }

  void _onAddressDefaultToggled(
    AddressDefaultToggledEvent event,
    Emitter<AddAddressState> emit,
  ) {
    emit(AddAddressInitial(
      selectedLabel: state.selectedLabel,
      isDefault: event.isDefault,
    ));
  }

  Future<void> _onSubmitAddress(
    SubmitAddressEvent event,
    Emitter<AddAddressState> emit,
  ) async {
    // 1. Validation Logic
    final name = event.name.trim();
    final mobile = event.mobile.trim();
    final addressLine1 = event.addressLine1.trim();
    final addressLine2 = event.addressLine2.trim();
    final city = event.city.trim();
    final stateName = event.state.trim();
    final pincode = event.pincode.trim();

    if (name.isEmpty || name.length < 2) {
      emit(AddAddressFailure(
        error: 'Please enter a valid receiver name (min 2 characters)',
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
      return;
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      emit(AddAddressFailure(
        error: 'Please enter a valid 10-digit mobile number',
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
      return;
    }

    if (addressLine1.isEmpty) {
      emit(AddAddressFailure(
        error: 'Please enter flat / house no / floor',
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
      return;
    }

    if (addressLine2.isEmpty) {
      emit(AddAddressFailure(
        error: 'Please enter street, area or sector',
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
      return;
    }

    if (city.isEmpty) {
      emit(AddAddressFailure(
        error: 'Please enter city',
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
      return;
    }

    if (stateName.isEmpty) {
      emit(AddAddressFailure(
        error: 'Please enter state',
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(pincode)) {
      emit(AddAddressFailure(
        error: 'Please enter a valid 6-digit pincode',
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
      return;
    }

    // 2. Loading State
    emit(AddAddressLoading(
      selectedLabel: state.selectedLabel,
      isDefault: state.isDefault,
    ));

    try {
      final request = AddAddressRequest(
        name: name,
        mobile: mobile,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: stateName,
        pincode: pincode,
        landmark: event.landmark,
        label: event.label,
        isDefault: event.isDefault,
      );

      final response = await _addressRepository.addAddress(request);

      final Map<String, dynamic> responseData =
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : (response.data is Map
                  ? Map<String, dynamic>.from(response.data as Map)
                  : <String, dynamic>{});

      final addAddressResponse = AddAddressResponse.fromJson(responseData);

      if (addAddressResponse.success) {
        // Save added address as current address in SharedPreferences
        final prefs = await SharedPreferencesService.getInstance();
        final displayAddress = '$addressLine1, $addressLine2, $city';
        await prefs.setString(AppKeys.currentAddress, displayAddress);

        emit(AddAddressSuccess(
          response: addAddressResponse,
          selectedLabel: state.selectedLabel,
          isDefault: state.isDefault,
        ));
      } else {
        emit(AddAddressFailure(
          error: addAddressResponse.message.isNotEmpty
              ? addAddressResponse.message
              : 'Failed to add address',
          selectedLabel: state.selectedLabel,
          isDefault: state.isDefault,
        ));
      }
    } on DioException catch (dioError) {
      String errorMessage = 'Failed to add address. Please try again.';
      if (dioError.response?.data is Map &&
          dioError.response?.data['message'] != null) {
        errorMessage = dioError.response!.data['message'].toString();
      } else {
        errorMessage = NetworkExceptions.getErrorMessage(dioError);
      }
      emit(AddAddressFailure(
        error: errorMessage,
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
    } catch (e) {
      emit(AddAddressFailure(
        error: e.toString(),
        selectedLabel: state.selectedLabel,
        isDefault: state.isDefault,
      ));
    }
  }
}
