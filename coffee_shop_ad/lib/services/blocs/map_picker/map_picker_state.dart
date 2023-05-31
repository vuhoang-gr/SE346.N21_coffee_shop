import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapPickerState {
  final GoogleMapController? controller;
  MapPickerState({required this.controller});
}

class LoaddingLocation extends MapPickerState {
  LoaddingLocation({required super.controller});
}

class LoaddedErrorLocation extends MapPickerState {
  LoaddedErrorLocation({required super.controller});
}

class LoaddedLocation extends MapPickerState {
  final String currentLocation;
  final double zoom;
  LoaddedLocation(
      {required this.currentLocation,
      required super.controller,
      this.zoom = 20});

  LoaddedLocation copyWith({
    required String currentLocation,
  }) {
    return LoaddedLocation(
      currentLocation: currentLocation,
      controller: controller,
    );
  }
}
