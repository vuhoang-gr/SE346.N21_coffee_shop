import 'package:coffee_shop_staff/services/apis/store_api.dart';
import 'package:coffee_shop_staff/services/models/store_product.dart';

// ignore: must_be_immutable
class FoodChecker extends StoreProduct {
  String id;
  List<String>? blockSize;

  FoodChecker(
      {required this.id,
      required item,
      this.blockSize,
      isStocking = false,
      store})
      : super(isStocking: isStocking, item: item, store: store) {
    blockSize ??= [];
    if (StoreAPI.currentStore != null) {
      this.store = StoreAPI.currentStore!;
    }
  }

  @override
  List<Object?> get props => [id];
}
