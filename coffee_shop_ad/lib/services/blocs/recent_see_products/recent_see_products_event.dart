import 'package:coffee_shop_admin/services/models/drink.dart';

abstract class RecentSeeProductsEvent {}

class ListRecentSeeProductChanged extends RecentSeeProductsEvent {
  final Drink product;

  ListRecentSeeProductChanged({required this.product});
}

class ListRecentSeeProductLoaded extends RecentSeeProductsEvent {
  ListRecentSeeProductLoaded();
}
