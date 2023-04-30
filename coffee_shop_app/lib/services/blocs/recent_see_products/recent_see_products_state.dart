import '../../models/food.dart';

abstract class RecentSeeProductsState {
  final List<Food> recentSeeProducts;
  RecentSeeProductsState({required this.recentSeeProducts});
}

class LoaddedDataState extends RecentSeeProductsState {
  LoaddedDataState({required super.recentSeeProducts});
}

class LoadingDataState extends RecentSeeProductsState {
  LoadingDataState() : super(recentSeeProducts: []);
}

class NotExistDataState extends RecentSeeProductsState {
  NotExistDataState() : super(recentSeeProducts: []);
}
