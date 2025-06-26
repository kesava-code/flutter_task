// File: lib/features/0_auth/cubit/signup/signup_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';
import 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(const SignUpState());

  Future<void> fetchCountries() async {
    try {
      final countries = await _authRepository.getCountryList();
      emit(state.copyWith(countries: countries));
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required String country,
    required String mobile,
  }) async {
    if (state.status == SignUpStatus.loading) return;
    emit(state.copyWith(status: SignUpStatus.loading));
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        displayName: displayName,
        country: country,
        mobile: mobile,
      );
      emit(state.copyWith(status: SignUpStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SignUpStatus.failure, errorMessage: e.toString()));
    }
  }
}
