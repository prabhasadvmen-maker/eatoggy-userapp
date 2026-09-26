import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network_exceptions.dart';
import '../data/models/get_tiffin_plans_request.dart';
import '../data/models/get_tiffin_plans_response.dart';
import '../data/repositories/subscription_repository.dart';
import 'subscription_plans_event.dart';
import 'subscription_plans_state.dart';

export 'subscription_plans_event.dart';
export 'subscription_plans_state.dart';

class SubscriptionPlansBloc
    extends Bloc<SubscriptionPlansEvent, SubscriptionPlansState> {
  final SubscriptionRepository _subscriptionRepository;

  SubscriptionPlansBloc({
    required SubscriptionRepository subscriptionRepository,
  })  : _subscriptionRepository = subscriptionRepository,
        super(const SubscriptionPlansInitial()) {
    on<FetchSubscriptionPlansEvent>(_onFetchPlans);
    on<RefreshSubscriptionPlansEvent>(_onRefreshPlans);
  }

  Future<void> _onFetchPlans(
    FetchSubscriptionPlansEvent event,
    Emitter<SubscriptionPlansState> emit,
  ) async {
    emit(const SubscriptionPlansLoading());
    await _loadPlans(
      emit,
      request: GetTiffinPlansRequest(
        mealType: event.mealType,
        status: event.status,
      ),
    );
  }

  Future<void> _onRefreshPlans(
    RefreshSubscriptionPlansEvent event,
    Emitter<SubscriptionPlansState> emit,
  ) async {
    await _loadPlans(emit);
  }

  Future<void> _loadPlans(
    Emitter<SubscriptionPlansState> emit, {
    GetTiffinPlansRequest? request,
  }) async {
    try {
      final response = await _subscriptionRepository.getTiffinPlans(
        request: request ?? const GetTiffinPlansRequest(),
      );

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      final tiffinResponse = GetTiffinPlansResponse.fromJson(data);

      if (tiffinResponse.success && tiffinResponse.data != null) {
        emit(SubscriptionPlansLoaded(
          plans: tiffinResponse.data!.plans,
          message: tiffinResponse.message,
        ));
      } else {
        emit(SubscriptionPlansFailure(
          error: tiffinResponse.message.isNotEmpty
              ? tiffinResponse.message
              : 'Failed to retrieve tiffin plans.',
        ));
      }
    } on DioException catch (e) {
      emit(SubscriptionPlansFailure(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(SubscriptionPlansFailure(error: e.toString()));
    }
  }
}
