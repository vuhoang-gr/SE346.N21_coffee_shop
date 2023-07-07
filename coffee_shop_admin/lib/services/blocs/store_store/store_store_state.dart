import 'package:coffee_shop_admin/services/models/store.dart';

abstract class StoreStoreState {
  StoreStoreState();
}

class LoadingState extends StoreStoreState {
  LoadingState();
}

class ErrorState extends StoreStoreState {
  ErrorState();
}

class LoadedState extends StoreStoreState {
  final List<Store> stores;

  LoadedState({
    required this.stores,
  });
}
