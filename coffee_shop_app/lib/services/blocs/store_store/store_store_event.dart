import 'package:coffee_shop_app/services/models/store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class StoreStoreEvent {}

class FetchData extends StoreStoreEvent {
  final LatLng? location;
  FetchData({required this.location});
}

class UpdateFavorite extends StoreStoreEvent {
  final Store store;
  UpdateFavorite({required this.store});
}

class GetDataFetched extends StoreStoreEvent {
  final List<Store> allStores;
  final LatLng? latLng;
  GetDataFetched({required this.allStores, required this.latLng});
}
