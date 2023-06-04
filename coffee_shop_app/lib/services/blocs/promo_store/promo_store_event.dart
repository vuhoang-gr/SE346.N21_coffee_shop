import '../../models/promo.dart';

abstract class PromoStoreEvent {}

class FetchData extends PromoStoreEvent {}

class GetDataFetched extends PromoStoreEvent {
  final List<Promo> listPromos;
  GetDataFetched({required this.listPromos});
}
