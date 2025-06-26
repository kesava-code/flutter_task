// File: lib/features/3_map/cubit/map_cubit.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/3_map/domain/repositories/map_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_state.dart';
import 'package:geolocator/geolocator.dart';

class MapCubit extends Cubit<MapState> {
  final MapRepository _mapRepository;
  StreamSubscription<Position>? _locationSubscription;
  GoogleMapController? mapController;

  MapCubit(this._mapRepository) : super(const MapState());

  Future<void> initializeMap() async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      final position = await _mapRepository.getCurrentLocation();
      _updateMapWithPosition(position);

      // Start listening to location updates
      _locationSubscription = _mapRepository.getLocationStream().listen((position) {
        _updateMapWithPosition(position);
        mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
      });
    } catch (e) {
      emit(state.copyWith(status: MapStatus.failure, errorMessage: e.toString()));
    }
  }

  void _updateMapWithPosition(Position position) {
    final newCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );

    final userMarker = Marker(
      markerId: const MarkerId('user_location'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(title: 'Your Location'),
    );

    final rectangle = _createRectangleForLocation(LatLng(position.latitude, position.longitude));

    emit(state.copyWith(
      status: MapStatus.success,
      initialPosition: newCameraPosition,
      markers: {userMarker},
      polygons: {rectangle},
    ));
  }

  Polygon _createRectangleForLocation(LatLng center) {
    // 1 degree of latitude is ~111.1 km. 1 km is ~0.009 degrees.
    const double latOffset = 0.009; // Approx 1km
    const double lonOffset = 0.009; // Approx 1km

    return Polygon(
      polygonId: const PolygonId('user_radius'),
      points: [
        LatLng(center.latitude - latOffset, center.longitude - lonOffset),
        LatLng(center.latitude + latOffset, center.longitude - lonOffset),
        LatLng(center.latitude + latOffset, center.longitude + lonOffset),
        LatLng(center.latitude - latOffset, center.longitude + lonOffset),
      ],
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.2),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    mapController?.dispose();
    return super.close();
  }
}
