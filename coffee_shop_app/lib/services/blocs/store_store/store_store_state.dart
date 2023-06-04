import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/store.dart';

abstract class StoreStoreState {
  final List<Store> initStores;
  final Store? selectedStore;
  StoreStoreState({required this.initStores, required this.selectedStore});
}

abstract class HasDataStoreStoreState extends StoreStoreState {
  final LatLng? latLng;
  Store? nearestStore;
  final List<Store> listFavoriteStore;
  final List<Store> listOtherStore;
  HasDataStoreStoreState(
      {required this.latLng,
      required this.listFavoriteStore,
      required this.listOtherStore,
      required super.initStores,
      required super.selectedStore,
      required this.nearestStore});
}

class LoadingState extends StoreStoreState {
  LoadingState({required super.initStores, required super.selectedStore});
}

class ErrorState extends StoreStoreState {
  ErrorState({required super.initStores, required super.selectedStore});
}

class LoadedState extends HasDataStoreStoreState {
  LoadedState(
      {required super.latLng,
      required super.listFavoriteStore,
      required super.listOtherStore,
      required super.initStores,
      required super.selectedStore,
      required super.nearestStore});
}

class FetchedState extends HasDataStoreStoreState {
  FetchedState(
      {required super.latLng,
      required super.listFavoriteStore,
      required super.listOtherStore,
      required super.initStores,
      required super.selectedStore,
      required super.nearestStore});
}
