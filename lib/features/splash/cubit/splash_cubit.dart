import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/storage_service.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}

class SplashNavigateToHome extends SplashState {}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initSplash() async {
    emit(SplashLoading());

    await Future.delayed(const Duration(milliseconds: 2000));

    try {
      final prefs = await SharedPreferencesService.getInstance();
      final token = prefs.getString(AppKeys.accessToken);

      if (token != null && token.trim().isNotEmpty) {
        emit(SplashNavigateToHome());
      } else {
        emit(SplashNavigateToOnboarding());
      }
    } catch (_) {
      emit(SplashNavigateToOnboarding());
    }
  }
}
