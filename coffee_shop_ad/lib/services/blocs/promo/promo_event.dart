import '../../models/promo.dart';

abstract class PromoEvent {}

class FetchData extends PromoEvent {}

class GetDataFetched extends PromoEvent {
  final List<Promo> listPromos;
  final List<String> listCodes;
  GetDataFetched({required this.listPromos, required this.listCodes});
}
