// File: lib/features/0_auth/domain/repositories/auth_repository.dart
import 'package:flutter_task/features/0_auth/domain/entities/country_entity.dart';
import 'package:flutter_task/features/0_auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get user;
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required String country,
    required String mobile,
  });
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<List<CountryEntity>> getCountryList();
}
