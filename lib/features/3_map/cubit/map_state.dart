// File: lib/features/3_map/cubit/map_state.dart
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapStatus { initial, loading, success, failure }

class MapState extends Equatable {
  final MapStatus status;
  final CameraPosition? initialPosition;
  final Set<Marker> markers;
  final Set<Polygon> polygons;
  final String? errorMessage;

  const MapState({
    this.status = MapStatus.initial,
    this.initialPosition,
    this.markers = const {},
    this.polygons = const {},
    this.errorMessage,
  });

  MapState copyWith({
    MapStatus? status,
    CameraPosition? initialPosition,
    Set<Marker>? markers,
    Set<Polygon>? polygons,
    String? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      initialPosition: initialPosition ?? this.initialPosition,
      markers: markers ?? this.markers,
      polygons: polygons ?? this.polygons,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, initialPosition, markers, polygons, errorMessage];
}
