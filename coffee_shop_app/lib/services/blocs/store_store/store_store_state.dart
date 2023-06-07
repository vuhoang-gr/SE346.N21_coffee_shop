import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/store.dart';

abstract class StoreStoreState {
  final List<Store> initStores;
  final LatLng? latLng;
  StoreStoreState({required this.initStores, required this.latLng});
}

abstract class HasDataStoreStoreState extends StoreStoreState {
  Store? nearestStore;
  final List<Store> listFavoriteStore;
  final List<Store> listOtherStore;
  HasDataStoreStoreState(
      {required super.latLng,
      required this.listFavoriteStore,
      required this.listOtherStore,
      required this.nearestStore,
      required super.initStores});
}

class LoadingState extends StoreStoreState {
  LoadingState({required super.initStores, required super.latLng});
}

class ErrorState extends StoreStoreState {
  ErrorState({required super.initStores, required super.latLng});
}

class LoadedState extends HasDataStoreStoreState {
  LoadedState(
      {required super.latLng,
      required super.listFavoriteStore,
      required super.listOtherStore,
      required super.nearestStore,
      required super.initStores});
}

class FetchedState extends HasDataStoreStoreState {
  FetchedState(
      {required super.latLng,
      required super.listFavoriteStore,
      required super.listOtherStore,
      required super.nearestStore,
      required super.initStores});
}
