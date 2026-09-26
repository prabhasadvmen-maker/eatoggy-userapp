import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  final String message;
  const LocationLoading({this.message = 'Detecting current location...'});

  @override
  List<Object?> get props => [message];
}

class LocationSuccess extends LocationState {
  final double latitude;
  final double longitude;
  final String address;

  const LocationSuccess({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}

class LocationFailure extends LocationState {
  final String message;
  final bool isServiceDisabled;
  final bool isPermissionPermanentlyDenied;

  const LocationFailure({
    required this.message,
    this.isServiceDisabled = false,
    this.isPermissionPermanentlyDenied = false,
  });

  @override
  List<Object?> get props => [
        message,
        isServiceDisabled,
        isPermissionPermanentlyDenied,
      ];
}

class LocationSkipped extends LocationState {
  const LocationSkipped();
}
