import 'package:coffee_shop_admin/services/models/store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class StoreStoreEvent {}

class FetchData extends StoreStoreEvent {
  FetchData();
}

class RemoveStore extends StoreStoreEvent {
  RemoveStore();
}
