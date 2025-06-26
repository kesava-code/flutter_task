// File: lib/features/0_auth/bloc/auth_bloc.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/0_auth/domain/entities/user_entity.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);

    _userSubscription = _authRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(
      event.user != null
          ? AuthState.authenticated(event.user!)
          : const AuthState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    _authRepository.logOut();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
