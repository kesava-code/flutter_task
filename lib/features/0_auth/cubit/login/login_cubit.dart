// File: lib/features/0_auth/cubit/login/login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

  Future<void> logInWithCredentials(String email, String password) async {
    if (state.status == LoginStatus.loading) return;
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }
}
