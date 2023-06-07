import 'package:coffee_shop_app/services/models/topping.dart';

import '../../models/food.dart';
import '../../models/size.dart';

class ProductDetailState {
  final Food? selectedFood;
  final List<String> bannedSize;
  final List<String> bannedTopping;
  ProductDetailState(
      {required this.selectedFood,
      required this.bannedSize,
      required this.bannedTopping});
}

class LoadingState extends ProductDetailState {
  LoadingState(
      {required super.selectedFood,
      required super.bannedSize,
      required super.bannedTopping});
}

class ErrorState extends ProductDetailState {
  ErrorState(
      {required super.selectedFood,
      required super.bannedSize,
      required super.bannedTopping});
}

class InitState extends ProductDetailState {
  InitState(
      {required super.selectedFood,
      required super.bannedSize,
      required super.bannedTopping});
}

class DisposeState extends ProductDetailState {
  DisposeState(
      {required super.selectedFood,
      required super.bannedSize,
      required super.bannedTopping});
}
class LoadedState extends ProductDetailState {
  final List<Size> productsSize;
  final List<Topping> productsTopping;
  final Size selectedSize;
  final List<bool> selectedToppings;
  final int numberToAdd;
  final double totalPrice;

  LoadedState(
      {required super.selectedFood,
      required this.productsSize,
      required this.productsTopping,
      required this.selectedSize,
      required this.selectedToppings,
      required this.numberToAdd,
      required this.totalPrice,
      required super.bannedSize,
      required super.bannedTopping});
}