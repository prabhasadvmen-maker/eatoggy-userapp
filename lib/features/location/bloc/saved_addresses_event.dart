import 'package:equatable/equatable.dart';
import '../data/models/add_address_response.dart';

abstract class SavedAddressesEvent extends Equatable {
  const SavedAddressesEvent();

  @override
  List<Object?> get props => [];
}

class FetchSavedAddressesEvent extends SavedAddressesEvent {
  const FetchSavedAddressesEvent();
}

class SelectActiveAddressEvent extends SavedAddressesEvent {
  final CustomerAddressData address;
  const SelectActiveAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteSavedAddressEvent extends SavedAddressesEvent {
  final String addressId;
  const DeleteSavedAddressEvent(this.addressId);

  @override
  List<Object?> get props => [addressId];
}
