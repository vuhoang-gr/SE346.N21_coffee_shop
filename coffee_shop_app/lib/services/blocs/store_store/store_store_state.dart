import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/store.dart';

abstract class StoreStoreState {}

class LoadingState extends StoreStoreState {
  LoadingState();
}

class FetchedState extends StoreStoreState {
  final List<Store> initStores;
  final LatLng? latLng;
  FetchedState({required this.initStores, required this.latLng});
}

class ErrorState extends StoreStoreState {
  ErrorState();
}

class LoadedState extends StoreStoreState {
  final List<Store> initStores;
  final LatLng? latLng;
  Store? nearestStore;
  final List<Store> listFavoriteStore;
  final List<Store> listOtherStore;

  LoadedState(
      {required this.initStores,
      required this.latLng,
      required this.nearestStore,
      required this.listFavoriteStore,
      required this.listOtherStore});
}
