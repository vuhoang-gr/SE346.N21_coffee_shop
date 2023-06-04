import 'package:coffee_shop_app/services/models/promo.dart';

abstract class PromoStoreEvent {}

class FetchData extends PromoStoreEvent {}

class UsePromo extends PromoStoreEvent {
  final Promo promo;
  UsePromo({required this.promo});
}
