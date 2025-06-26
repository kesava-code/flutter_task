// File: lib/features/4_settings/cubit/settings_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/4_settings/data/language_service.dart';

class SettingsCubit extends Cubit<Locale> {
  final LanguageService _languageService;

  SettingsCubit(this._languageService) : super(const Locale('en'));

  Future<void> loadInitialLanguage() async {
    final locale = await _languageService.loadLanguage();
    emit(locale);
  }

  Future<void> changeLanguage(String languageCode) async {
    await _languageService.saveLanguage(languageCode);
    emit(Locale(languageCode));
  }
}