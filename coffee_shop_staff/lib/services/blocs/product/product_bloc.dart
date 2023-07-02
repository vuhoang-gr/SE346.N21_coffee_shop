import 'package:bloc/bloc.dart';
import 'package:coffee_shop_staff/services/apis/food_api.dart';
import 'package:coffee_shop_staff/services/apis/store_api.dart';
import 'package:coffee_shop_staff/services/apis/topping_api.dart';
import 'package:coffee_shop_staff/services/models/food.dart';
import 'package:coffee_shop_staff/services/models/food_checker.dart';
import 'package:coffee_shop_staff/services/models/store_product.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ToppingAPI toppingAPI = ToppingAPI();

  ProductBloc() : super(ProductInitial()) {
    on<LoadProduct>((event, emit) async {
      emit(ProductLoading(shopID: event.storeID));
      //Load Topping
      var stateTopping = await loadTopping();
      //Load product
      var stateFood = await loadDrink();

      emit(ProductLoaded(topping: stateTopping, drink: stateFood));
    });

    on<ChangeProduct>(
      (event, emit) {
        var currentState = state;
        if (currentState is! ProductLoaded) {
          return;
        }
        var topping = currentState.topping;
        var drink = event.product;
        emit(ProductInitial());
        emit(ProductLoaded(topping: topping, drink: drink));
      },
    );
  }

  Future<List<StoreProduct>> loadTopping() async {
    var allTopping = await toppingAPI.getAll();
    var outTopping = StoreAPI.currentStore?.stateToppingRaw;
    List<StoreProduct> stateTopping = [];
    for (int i = 0; i < allTopping!.length; i++) {
      if (outTopping!.contains(allTopping[i]!.id)) {
        stateTopping.add(
          StoreProduct(
              item: allTopping[i],
              isStocking: false,
              store: StoreAPI.currentStore!),
        );
      } else {
        stateTopping.add(
          StoreProduct(
              item: allTopping[i],
              isStocking: true,
              store: StoreAPI.currentStore!),
        );
      }
    }
    StoreAPI.currentStore!.stateTopping = stateTopping;
    return stateTopping;
  }

  Future<List<FoodChecker>> loadDrink() async {
    if (StoreAPI.currentStore == null) return [];

    var allFood = await FoodAPI().getAll();
    var outFood = StoreAPI.currentStore!.stateFoodRaw;
    var allFoodChecker = FoodAPI().toChecker(allFood);

    // List<FoodChecker> stateFood = [];

    for (int i = 0; i < allFoodChecker.length; i++) {
      var item = allFoodChecker[i];

      if (!outFood.containsKey(item.id)) {
        item.isStocking = true;
        continue;
      }
      var outFoodTemp = outFood[item.id];
      if (outFoodTemp is bool) {
        item.blockSize = (item.item as Food).sizes?.map((e) => e.id).toList();
      } else {
        item.blockSize =
            (outFoodTemp as List<dynamic>).map((e) => e as String).toList();
      }
      item.isStocking =
          item.blockSize!.length < (item.item as Food).sizes!.length
              ? true
              : false;
    }
    // outFood.forEach((key, value) async {
    //   var food = await FoodAPI().get(key);
    //   List<String> blockSize = [];
    //   if (value is bool) {
    //     for (var it in food!.sizes!) {
    //       blockSize.add(it.id);
    //     }
    //   } else {
    //     blockSize = (value as List<dynamic>).map((e) => e as String).toList();
    //   }
    //   bool isStocking = food!.sizes!.length > blockSize.length ? true : false;

    //   stateFood.add(FoodChecker(
    //       id: food.id,
    //       item: food,
    //       isStocking: isStocking,
    //       store: StoreAPI.currentStore,
    //       blockSize: blockSize));
    // });
    StoreAPI.currentStore!.stateFood = allFoodChecker;
    return allFoodChecker;
  }
}
