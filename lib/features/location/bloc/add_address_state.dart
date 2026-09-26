import 'package:equatable/equatable.dart';
import '../data/models/add_address_response.dart';

abstract class AddAddressState extends Equatable {
  final String selectedLabel;
  final bool isDefault;

  const AddAddressState({
    this.selectedLabel = 'Home',
    this.isDefault = true,
  });

  @override
  List<Object?> get props => [selectedLabel, isDefault];
}

class AddAddressInitial extends AddAddressState {
  const AddAddressInitial({
    super.selectedLabel = 'Home',
    super.isDefault = true,
  });
}

class AddAddressLoading extends AddAddressState {
  const AddAddressLoading({
    super.selectedLabel,
    super.isDefault,
  });
}

class AddAddressSuccess extends AddAddressState {
  final AddAddressResponse response;

  const AddAddressSuccess({
    required this.response,
    super.selectedLabel,
    super.isDefault,
  });

  @override
  List<Object?> get props => [response, selectedLabel, isDefault];
}

class AddAddressFailure extends AddAddressState {
  final String error;

  const AddAddressFailure({
    required this.error,
    super.selectedLabel,
    super.isDefault,
  });

  @override
  List<Object?> get props => [error, selectedLabel, isDefault];
}
