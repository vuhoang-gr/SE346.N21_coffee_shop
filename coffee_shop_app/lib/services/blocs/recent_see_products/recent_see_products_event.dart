import 'package:coffee_shop_app/services/models/food.dart';

abstract class RecentSeeProductsEvent {}

class ListRecentSeeProductChanged extends RecentSeeProductsEvent {
  final Food product;

  ListRecentSeeProductChanged({required this.product});
}

class ListRecentSeeProductLoaded extends RecentSeeProductsEvent {
  ListRecentSeeProductLoaded();
}
