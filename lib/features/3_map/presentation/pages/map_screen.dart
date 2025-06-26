// File: lib/features/3_map/presentation/pages/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/app_config/theme/map_styles.dart';
import 'package:flutter_task/features/3_map/cubit/map_cubit.dart';
import 'package:flutter_task/features/3_map/cubit/map_state.dart';
import 'package:flutter_task/features/3_map/data/repositories/map_repository_impl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapCubit(MapRepositoryImpl())..initializeMap(),
      child: const MapView(),
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        if (state.status == MapStatus.loading || state.status == MapStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == MapStatus.failure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(state.errorMessage ?? 'Failed to load map. Please enable location services.'),
            ),
          );
        }

        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: state.initialPosition!,
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(mapStyle);
            context.read<MapCubit>().onMapCreated(controller);
          },
          markers: state.markers,
          polygons: state.polygons,
          myLocationEnabled: true, // Shows the blue dot for user's location
          myLocationButtonEnabled: true,
        );
      },
    );
  }
}
