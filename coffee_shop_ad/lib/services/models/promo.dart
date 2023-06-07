// ignore_for_file: public_member_api_docs, sort_constructors_first
class Promo {
  final String id;
  final double minPrice;
  final double maxPrice;
  final double percent;
  final DateTime dateEnd;
  final DateTime dateStart;
  final String description;
  final List<String> products;
  final List<String> stores;
  final bool forNewCustomer;

  Promo({
    required this.id,
    required this.minPrice,
    required this.maxPrice,
    required this.percent,
    required this.description,
    required this.dateEnd,
    required this.dateStart,
    required this.products,
    required this.stores,
    required this.forNewCustomer,
  });
}
