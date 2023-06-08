class Promo {
  final String id;
  final double minPrice;
  final double maxPrice;
  final double percent;
  final DateTime dateStart;
  final DateTime dateEnd;
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
    required this.dateStart,
    required this.dateEnd,
    required this.products,
    required this.stores,
    required this.forNewCustomer,
  });
}
