// File: lib/features/0_auth/data/repositories/auth_repository_impl.dart
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_task/features/0_auth/domain/entities/country_entity.dart';
import 'package:flutter_task/features/0_auth/domain/entities/user_entity.dart';
import 'package:flutter_task/features/0_auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FlutterSecureStorage? secureStorage,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _userSessionKey = 'user_session';

  @override
  Stream<UserEntity?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        _secureStorage.delete(key: _userSessionKey);
        return null;
      }
      _secureStorage.write(key: _userSessionKey, value: firebaseUser.uid);
      return UserEntity(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
      );
    });
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required String country,
    required String mobile,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'displayName': displayName,
          'country': country,
          'mobile': mobile,
          'uid': userCredential.user!.uid,
        });
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<List<CountryEntity>> getCountryList() async {
    try {
      final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all?fields=name,idd'));
      if (response.statusCode == 200) {
        List<CountryEntity> countries = parseCountries(response.body);
        countries.sort((a, b) => a.name.compareTo(b.name));
        // Filter out countries with no dial code
        return countries.where((c) => c.dialCode.isNotEmpty).toList();
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      // In case of any error, return an empty list
      return [];
    }
  }
}
