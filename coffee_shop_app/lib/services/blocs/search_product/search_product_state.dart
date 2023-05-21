import 'package:coffee_shop_app/services/models/food.dart';

abstract class SearchProductState {
  final List<Food> initProductList;
  SearchProductState({required this.initProductList});
}

class LoadedListFood extends SearchProductState {
  final List<Food> searchStoreResults;
  LoadedListFood({
    required super.initProductList,
    required this.searchStoreResults,
  });
}

class LoadingListFood extends SearchProductState {
  LoadingListFood({
    required super.initProductList,
  });
}

class EmptyListFood extends SearchProductState {
  EmptyListFood({
    required super.initProductList,
  });
}