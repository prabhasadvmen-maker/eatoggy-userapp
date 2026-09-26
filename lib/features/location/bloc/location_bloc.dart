import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/storage_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final Geocoding _geocoding = Geocoding();

  LocationBloc() : super(const LocationInitial()) {
    on<RequestCurrentLocationEvent>(_onRequestCurrentLocation);
    on<SkipLocationEvent>(_onSkipLocation);
    on<OpenLocationSettingsEvent>(_onOpenLocationSettings);
    on<OpenAppSettingsEvent>(_onOpenAppSettings);
  }

  Future<void> _onRequestCurrentLocation(
    RequestCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading(message: 'Checking GPS service...'));

    try {
      // 1. Check if device location service is enabled
      final bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        emit(const LocationFailure(
          message: 'GPS service is disabled. Please enable location on your device.',
          isServiceDisabled: true,
        ));
        return;
      }

      // 2. Check and request runtime permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const LocationFailure(
            message: 'Location permission was denied. Please allow access to detect nearby kitchens.',
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const LocationFailure(
          message: 'Location permission is permanently denied. Please enable it in App Settings.',
          isPermissionPermanentlyDenied: true,
        ));
        return;
      }

      emit(const LocationLoading(message: 'Detecting your coordinates...'));

      // 3. Acquire GPS Position (with fallback to last known)
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        emit(const LocationFailure(
          message: 'Could not determine your current position. Please try again.',
        ));
        return;
      }

      emit(const LocationLoading(message: 'Resolving your address...'));

      // 4. Reverse Geocoding to get human-readable address
      String formattedAddress = '';
      try {
        final List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final Placemark place = placemarks.first;
          final String subLocality = place.subLocality ?? place.name ?? '';
          final String locality = place.locality ?? place.subAdministrativeArea ?? '';

          if (subLocality.isNotEmpty && locality.isNotEmpty) {
            formattedAddress = '$subLocality, $locality';
          } else if (locality.isNotEmpty) {
            formattedAddress = locality;
          } else if (subLocality.isNotEmpty) {
            formattedAddress = subLocality;
          }
        }
      } catch (_) {
        // Fallback gracefully if geocoding fails (e.g. offline)
      }

      if (formattedAddress.isEmpty) {
        formattedAddress = 'Current Location';
      }

      // 5. Save location details in SharedPreferences
      final prefs = await SharedPreferencesService.getInstance();
      await prefs.setDouble(AppKeys.latitude, position.latitude);
      await prefs.setDouble(AppKeys.longitude, position.longitude);
      await prefs.setString(AppKeys.currentAddress, formattedAddress);

      emit(LocationSuccess(
        latitude: position.latitude,
        longitude: position.longitude,
        address: formattedAddress,
      ));
    } catch (e) {
      emit(LocationFailure(
        message: 'Failed to retrieve location: ${e.toString()}',
      ));
    }
  }

  void _onSkipLocation(
    SkipLocationEvent event,
    Emitter<LocationState> emit,
  ) {
    emit(const LocationSkipped());
  }

  Future<void> _onOpenLocationSettings(
    OpenLocationSettingsEvent event,
    Emitter<LocationState> emit,
  ) async {
    await Geolocator.openLocationSettings();
  }

  Future<void> _onOpenAppSettings(
    OpenAppSettingsEvent event,
    Emitter<LocationState> emit,
  ) async {
    await Geolocator.openAppSettings();
  }
}
