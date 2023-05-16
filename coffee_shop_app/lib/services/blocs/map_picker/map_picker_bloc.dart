import 'package:coffee_shop_app/services/blocs/map_picker/map_picker_event.dart';
import 'package:coffee_shop_app/services/blocs/map_picker/map_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerBloc extends Bloc<MapPickerEvent, MapPickerState> {
  MapPickerBloc() : super(LoaddingLocation(controller: null)) {
    on<MoveCamera>(_mapMoveCamera);
    on<UpdatingLocation>(_mapUpdatingLocation);
    on<UpdatedLocation>(_mapUpdatedLocation);
    on<InitController>(_mapUpdateController);
  }

  Future<void> _mapMoveCamera(
      MoveCamera event, Emitter<MapPickerState> emit) async {
    if (state.controller != null) {
      try {
        emit(LoaddingLocation(controller: state.controller));
        await state.controller!
            .animateCamera(CameraUpdate.newLatLng(event.location));

        String address = await _getAddress(event.location);
        emit(LoaddedLocation(
            currentLocation: address, controller: state.controller));
      } catch (e) {
        emit(LoaddedErrorLocation(controller: state.controller));
      }
    } else {
      emit(LoaddedErrorLocation(controller: state.controller));
    }
  }

  Future<void> _mapUpdatedLocation(
      UpdatedLocation event, Emitter<MapPickerState> emit) async {
    emit(LoaddingLocation(controller: state.controller));
    try {
      String address = await _getAddress(event.location);
      emit(LoaddedLocation(
          currentLocation: address, controller: state.controller));
    } catch (e) {
      emit(LoaddedErrorLocation(controller: state.controller)); 
    }
  }

  Future<void> _mapUpdateController(
      InitController event, Emitter<MapPickerState> emit) async {
    emit(LoaddingLocation(controller: event.controller));
    try {
      String address = await _getAddress(event.currentLocation);
      emit(LoaddedLocation(
          currentLocation: address, controller: state.controller));
    } catch (e) {
      emit(LoaddedErrorLocation(controller: state.controller));
    }
  }

  void _mapUpdatingLocation(
      UpdatingLocation event, Emitter<MapPickerState> emit) {
    emit(LoaddingLocation(controller: state.controller));
  }

  Future _getAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark address = placemarks[0]; // get only first and closest address
      String addresStr =
          "${address.street}, ${address.subAdministrativeArea}, ${address.administrativeArea}";
      return addresStr;
    } else {
      throw Exception('Could not find address for location');
    }
  }
}
