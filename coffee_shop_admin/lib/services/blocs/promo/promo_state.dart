import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/services/models/promo.dart';
import 'package:coffee_shop_admin/services/models/store.dart';

abstract class PromoState {
  final List<Promo> initPromos;
  final List<String> listExistCode;
  final List<Store> stores;
  final List<Drink> drinks;
  PromoState({required this.initPromos, required this.listExistCode, required this.stores, required this.drinks});
}

class LoadingState extends PromoState {
  LoadingState({required super.initPromos, required super.listExistCode, required super.stores, required super.drinks});
}

class ErrorState extends PromoState {
  ErrorState({required super.initPromos, required super.listExistCode, required super.stores, required super.drinks});
}

class LoadedState extends PromoState {
  LoadedState({required super.initPromos, required super.listExistCode, required super.stores, required super.drinks});
}
