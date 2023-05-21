import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/store.dart';

abstract class StoreStoreState {
  final List<Store> initStore;
  final LatLng? latLng;
  StoreStoreState({required this.initStore, required this.latLng});
}

class LoadingState extends StoreStoreState {
  LoadingState({required super.initStore, required super.latLng});
}

class ErrorState extends StoreStoreState {
  ErrorState({required super.initStore, required super.latLng});
}

class LoadedState extends StoreStoreState {
  Store? nearestStore;
  final List<Store> listFavoriteStore;
  final List<Store> listOtherStore;

  LoadedState(
      {required super.initStore,
      required super.latLng,
      required this.nearestStore,
      required this.listFavoriteStore,
      required this.listOtherStore});
}
