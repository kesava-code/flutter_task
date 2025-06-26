// File: lib/features/0_auth/cubit/signup/signup_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_task/features/0_auth/domain/entities/country_entity.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  final SignUpStatus status;
  final List<CountryEntity> countries;
  final String? errorMessage;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.countries = const [],
    this.errorMessage,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    List<CountryEntity>? countries,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, countries, errorMessage];
}