import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapPickerEvent {}

class MoveCamera extends MapPickerEvent {
  final LatLng location;
  MoveCamera({required this.location});
}

class UpdatedLocation extends MapPickerEvent {
  final LatLng location;
  UpdatedLocation({required this.location});
}

class UpdatingLocation extends MapPickerEvent {
  UpdatingLocation();
}

class InitController extends MapPickerEvent {
  final GoogleMapController controller;
  final LatLng currentLocation;
  InitController({required this.controller, required this.currentLocation});
}
