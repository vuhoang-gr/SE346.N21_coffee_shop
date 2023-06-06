import 'package:coffee_shop_admin/services/models/promo.dart';

abstract class PromoState {
  final List<Promo> initPromos;
  PromoState({required this.initPromos});
}

class LoadingState extends PromoState {
  LoadingState({required super.initPromos});
}

class ErrorState extends PromoState {
  ErrorState({required super.initPromos});
}

class LoadedState extends PromoState {
  LoadedState({required super.initPromos});
}
