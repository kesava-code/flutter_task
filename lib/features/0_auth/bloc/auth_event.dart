// File: lib/features/0_auth/bloc/auth_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_task/features/0_auth/domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  const AuthUserChanged(this.user);
   @override
  List<Object> get props => [user ?? ''];
}

class AuthLogoutRequested extends AuthEvent {}


