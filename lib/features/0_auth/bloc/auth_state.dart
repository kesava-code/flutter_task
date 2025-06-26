// File: lib/features/0_auth/bloc/auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_task/features/0_auth/domain/entities/user_entity.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(UserEntity user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}
