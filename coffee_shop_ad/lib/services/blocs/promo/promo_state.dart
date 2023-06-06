import 'package:coffee_shop_admin/services/models/promo.dart';

abstract class PromoState {
  final List<Promo> initPromos;
  final List<String> listExistCode;
  PromoState({required this.initPromos, required this.listExistCode});
}

class LoadingState extends PromoState {
  LoadingState({required super.initPromos, required super.listExistCode});
}

class ErrorState extends PromoState {
  ErrorState({required super.initPromos, required super.listExistCode});
}

class LoadedState extends PromoState {
  LoadedState({required super.initPromos, required super.listExistCode});
}
