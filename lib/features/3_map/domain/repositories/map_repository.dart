// File: lib/features/3_map/domain/repositories/map_repository.dart
import 'package:geolocator/geolocator.dart';

abstract class MapRepository {
  Future<Position> getCurrentLocation();
  Stream<Position> getLocationStream();
}
