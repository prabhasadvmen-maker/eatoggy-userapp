import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network_exceptions.dart';
import '../data/models/get_profile_request.dart';
import '../data/models/get_profile_response.dart';
import '../data/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<RefreshProfileEvent>(_onRefreshProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    await _loadProfile(emit);
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _loadProfile(emit);
  }

  Future<void> _loadProfile(Emitter<ProfileState> emit) async {
    try {
      final response = await _profileRepository.getProfile(
        request: const GetProfileRequest(),
      );

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      final profileResponse = GetProfileResponse.fromJson(data);

      if (profileResponse.success && profileResponse.data?.customer != null) {
        emit(ProfileLoaded(
          customer: profileResponse.data!.customer!,
          message: profileResponse.message,
        ));
      } else {
        emit(ProfileFailure(
          error: profileResponse.message.isNotEmpty
              ? profileResponse.message
              : 'Failed to retrieve customer profile.',
        ));
      }
    } on DioException catch (e) {
      emit(ProfileFailure(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }
}
