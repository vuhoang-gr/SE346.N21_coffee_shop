import 'package:coffee_shop_staff/services/models/food.dart';
import 'package:coffee_shop_staff/services/models/store.dart';
import 'package:equatable/equatable.dart';

class StoreProduct extends Equatable {
  var item;
  bool isStocking;
  Store store;
  StoreProduct(
      {required this.item, required this.isStocking, required this.store});
  @override
  List<Object?> get props => [store.id, item.id];
}
