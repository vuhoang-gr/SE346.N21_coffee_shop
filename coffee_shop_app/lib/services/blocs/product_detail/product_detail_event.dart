import 'package:coffee_shop_app/services/models/food.dart';

import '../../models/size.dart';

class ProductDetailEvent {}

class InitProduct extends ProductDetailEvent {
  Food selectedProduct;
  List<String> bannedSize;
  List<String> bannedTopping;
  InitProduct(
      {required this.selectedProduct,
      required this.bannedSize,
      required this.bannedTopping});
}

class UpdateProduct extends ProductDetailEvent {
  UpdateProduct();
}

class DisposeProduct extends ProductDetailEvent {
  DisposeProduct();
}

class UpdateSize extends ProductDetailEvent {
  UpdateSize();
}

class UpdateTopping extends ProductDetailEvent {
  UpdateTopping();
}

class DecreaseAmount extends ProductDetailEvent {}

class IncreaseAmount extends ProductDetailEvent {}

class SelectSize extends ProductDetailEvent {
  Size selectedSize;
  SelectSize({required this.selectedSize});
}

class SelectTopping extends ProductDetailEvent {
  int index;
  SelectTopping({required this.index});
}

class SelectToppingWithValue extends ProductDetailEvent {
  int index;
  bool value;
  SelectToppingWithValue({required this.index, required this.value});
}
