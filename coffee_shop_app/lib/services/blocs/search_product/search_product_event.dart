import 'package:coffee_shop_app/services/models/food.dart';

abstract class SearchProductEvent {}

class SearchTextChanged extends SearchProductEvent {
  final String searchText;

  SearchTextChanged({required this.searchText});
}

class SearchClear extends SearchProductEvent {}

class UpdateList extends SearchProductEvent {
  final List<Food> initListFood;
  UpdateList({required this.initListFood});
}
