import 'package:equatable/equatable.dart';

abstract class AddAddressEvent extends Equatable {
  const AddAddressEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddressEvent extends AddAddressEvent {
  final String name;
  final String mobile;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final String label;
  final bool isDefault;

  const SubmitAddressEvent({
    required this.name,
    required this.mobile,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.label = 'Home',
    this.isDefault = true,
  });

  @override
  List<Object?> get props => [
        name,
        mobile,
        addressLine1,
        addressLine2,
        city,
        state,
        pincode,
        landmark,
        label,
        isDefault,
      ];
}

class AddressTypeChangedEvent extends AddAddressEvent {
  final String label;
  const AddressTypeChangedEvent(this.label);

  @override
  List<Object?> get props => [label];
}

class AddressDefaultToggledEvent extends AddAddressEvent {
  final bool isDefault;
  const AddressDefaultToggledEvent(this.isDefault);

  @override
  List<Object?> get props => [isDefault];
}
