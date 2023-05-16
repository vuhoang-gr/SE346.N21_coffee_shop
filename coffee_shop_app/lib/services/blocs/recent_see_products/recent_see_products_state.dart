import '../../models/food.dart';

abstract class RecentSeeProductsState {
  final List<Food> recentSeeProducts;
  RecentSeeProductsState({required this.recentSeeProducts});
}

class LoadedState extends RecentSeeProductsState {
  LoadedState({required super.recentSeeProducts});
}

class LoadingState extends RecentSeeProductsState {
  LoadingState() : super(recentSeeProducts: []);
}

class NotExistState extends RecentSeeProductsState {
  NotExistState() : super(recentSeeProducts: []);
}
