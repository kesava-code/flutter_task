// File: lib/features/0_auth/domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
  });

  @override
  List<Object?> get props => [uid, email, displayName];
}
