import 'package:equatable/equatable.dart';
import '../data/models/add_address_response.dart';

abstract class SavedAddressesState extends Equatable {
  const SavedAddressesState();

  @override
  List<Object?> get props => [];
}

class SavedAddressesInitial extends SavedAddressesState {
  const SavedAddressesInitial();
}

class SavedAddressesLoading extends SavedAddressesState {
  const SavedAddressesLoading();
}

class SavedAddressesLoaded extends SavedAddressesState {
  final List<CustomerAddressData> addresses;
  final String? activeAddressId;

  const SavedAddressesLoaded({
    required this.addresses,
    this.activeAddressId,
  });

  @override
  List<Object?> get props => [addresses, activeAddressId];
}

class SavedAddressesEmpty extends SavedAddressesState {
  const SavedAddressesEmpty();
}

class SavedAddressesFailure extends SavedAddressesState {
  final String error;

  const SavedAddressesFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class AddressDeleteSuccess extends SavedAddressesState {
  final String message;

  const AddressDeleteSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
