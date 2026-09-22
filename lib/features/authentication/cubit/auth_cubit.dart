import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final String? phoneNumber;
  final String? error;
  final bool requiresOtp;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.phoneNumber,
    this.error,
    this.requiresOtp = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? phoneNumber,
    String? error,
    bool? requiresOtp,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      error: error ?? this.error,
      requiresOtp: requiresOtp ?? this.requiresOtp,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, isLoading, phoneNumber, error, requiresOtp];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void sendOtp(String phone) {
    if (phone.length < 10) {
      emit(state.copyWith(error: 'Please enter a valid 10-digit phone number.'));
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    Future.delayed(const Duration(milliseconds: 800), () {
      emit(state.copyWith(isLoading: false, requiresOtp: true, phoneNumber: phone));
    });
  }

  void verifyOtp(String otp) {
    if (otp != '1234') {
      emit(state.copyWith(error: 'Invalid Verification Code. Use 1234 for demo.'));
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    Future.delayed(const Duration(milliseconds: 800), () {
      emit(state.copyWith(isLoading: false, isAuthenticated: true, requiresOtp: false));
    });
  }

  void logout() {
    emit(const AuthState());
  }
}
