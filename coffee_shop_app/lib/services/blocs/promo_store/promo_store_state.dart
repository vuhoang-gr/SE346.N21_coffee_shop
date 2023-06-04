import 'package:coffee_shop_app/services/models/promo.dart';

abstract class PromoStoreState {
  final List<Promo> initPromos;
  PromoStoreState({required this.initPromos});
}

class LoadingState extends PromoStoreState {
  LoadingState({required super.initPromos});
}

class ErrorState extends PromoStoreState {
  ErrorState({required super.initPromos});
}

class LoadedState extends PromoStoreState {
  LoadedState({required super.initPromos});
}
