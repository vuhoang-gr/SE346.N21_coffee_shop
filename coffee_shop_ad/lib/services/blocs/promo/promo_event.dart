import '../../models/promo.dart';

abstract class PromoEvent {}

class FetchData extends PromoEvent {}

class GetDataFetched extends PromoEvent {
  final List<Promo> listPromos;
  GetDataFetched({required this.listPromos});
}
