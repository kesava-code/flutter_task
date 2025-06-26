// File: lib/features/0_auth/domain/entities/country_entity.dart
import 'dart:convert';

class CountryEntity {
  final String name;
  final String dialCode;

  CountryEntity({required this.name, required this.dialCode});

  factory CountryEntity.fromJson(Map<String, dynamic> json) {
    String root = json['idd']['root'] ?? '';
    List<dynamic> suffixes = json['idd']['suffixes'] ?? [];
    String dialCode = root;
    if (suffixes.length == 1) {
      dialCode = root + suffixes[0];
    }

    return CountryEntity(
      name: json['name']['common'],
      dialCode: dialCode,
    );
  }
}

List<CountryEntity> parseCountries(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<CountryEntity>((json) => CountryEntity.fromJson(json)).toList();
}