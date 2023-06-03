// ignore_for_file: public_member_api_docs, sort_constructors_first
class Promo {
  final String id;
  final double minPrice;
  final double maxPrice;
  final double percent;
  final int numberTotal;
  int numberUsed;
  final DateTime dateBegin;
  final DateTime dateEnd;
  final List<String> products;
  final List<String> stores;
  final bool typeCustomer;

  Promo({
    required this.id,
    required this.minPrice,
    required this.maxPrice,
    required this.percent,
    required this.numberTotal,
    required this.numberUsed,
    required this.dateBegin,
    required this.dateEnd,
    required this.products,
    required this.stores,
    required this.typeCustomer,
  });
}
