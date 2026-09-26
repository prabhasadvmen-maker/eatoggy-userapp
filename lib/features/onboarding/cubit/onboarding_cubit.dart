import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void setPage(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void nextPage() {
    if (state.currentIndex < 2) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void previousPage() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }
}
