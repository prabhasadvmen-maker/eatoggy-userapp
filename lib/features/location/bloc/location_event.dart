import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class RequestCurrentLocationEvent extends LocationEvent {
  const RequestCurrentLocationEvent();
}

class SkipLocationEvent extends LocationEvent {
  const SkipLocationEvent();
}

class OpenLocationSettingsEvent extends LocationEvent {
  const OpenLocationSettingsEvent();
}

class OpenAppSettingsEvent extends LocationEvent {
  const OpenAppSettingsEvent();
}
