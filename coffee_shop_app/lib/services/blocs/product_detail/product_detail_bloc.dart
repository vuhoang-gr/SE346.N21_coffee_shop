import 'dart:async';

import 'package:coffee_shop_app/services/apis/food_api.dart';
import 'package:coffee_shop_app/services/apis/size_api.dart';
import 'package:coffee_shop_app/services/apis/topping_api.dart';
import 'package:coffee_shop_app/services/blocs/product_detail/product_detail_event.dart';
import 'package:coffee_shop_app/services/blocs/product_detail/product_detail_state.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_state.dart'
    as product_state;
import 'package:coffee_shop_app/services/blocs/size_store/size_store_state.dart'
    as size_state;
import 'package:coffee_shop_app/services/blocs/topping_store/topping_store_state.dart'
    as topping_state;
import 'package:coffee_shop_app/services/blocs/size_store/size_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/topping_store/topping_store_bloc.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/size.dart';
import '../../models/topping.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  StreamSubscription? _foodStoreSubscription;
  StreamSubscription? _toppingStoreSubscription;
  StreamSubscription? _sizeStoreSubscription;

  final ProductStoreBloc productStoreBloc;
  final ToppingStoreBloc toppingStoreBloc;
  final SizeStoreBloc sizeStoreBloc;

  ProductDetailBloc(
      {required this.productStoreBloc,
      required this.toppingStoreBloc,
      required this.sizeStoreBloc})
      : super(DisposeState(
            selectedFood: null, bannedSize: [], bannedTopping: [])) {
    on<InitProduct>(_mapInitProduct);
    on<UpdateProduct>(_mapUpdateProduct);
    on<UpdateSize>(_mapUpdateSize);
    on<UpdateTopping>(_mapUpdateTopping);
    on<DecreaseAmount>(_mapDecreaseAmount);
    on<IncreaseAmount>(_mapIncreaseAmount);
    on<DisposeProduct>(_mapDisposeProduct);
    on<SelectSize>(_mapSelectSize);
    on<SelectTopping>(_mapSelectTopping);
    on<SelectToppingWithValue>(_mapSelectToppingWithValue);
  }

  void _mapDisposeProduct(
      DisposeProduct event, Emitter<ProductDetailState> emit) {
    _foodStoreSubscription?.cancel();
    _toppingStoreSubscription?.cancel();
    _sizeStoreSubscription?.cancel();

    emit(DisposeState(
        selectedFood: state.selectedFood, bannedSize: [], bannedTopping: []));
  }

  void _mapInitProduct(InitProduct event, Emitter<ProductDetailState> emit) {
    if (state is DisposeState) {
      emit(InitState(
          selectedFood: event.selectedProduct,
          bannedSize: event.bannedSize,
          bannedTopping: event.bannedTopping));

      _foodStoreSubscription?.cancel();
      _foodStoreSubscription = productStoreBloc.stream.listen((state) {
        if (state is product_state.FetchedState) {
          add(UpdateProduct());
        }
      });

      _toppingStoreSubscription?.cancel();
      _toppingStoreSubscription = toppingStoreBloc.stream.listen((state) {
        if (state is topping_state.FetchedState) {
          add(UpdateTopping());
        }
      });

      _sizeStoreSubscription?.cancel();
      _sizeStoreSubscription = sizeStoreBloc.stream.listen((state) {
        if (state is size_state.FetchedState) {
          add(UpdateSize());
        }
      });

      Food selectedProduct = event.selectedProduct;

      List<Size> sizes = [];
      for (var size in SizeApi().currentSizes) {
        if (selectedProduct.sizes.contains(size.id) &&
            !state.bannedSize.contains(size.id)) {
          sizes.add(size);
        }
      }
      List<Topping> toppings = [];
      for (var topping in ToppingApi().currentToppings) {
        if (selectedProduct.toppings.contains(topping.id) &&
            !state.bannedTopping.contains(topping.id)) {
          toppings.add(topping);
        }
      }

      if (sizes.isNotEmpty) {
        emit(LoadedState(
            selectedFood: selectedProduct,
            productsSize: sizes,
            productsTopping: toppings,
            selectedSize: sizes[0],
            selectedToppings:
                List<bool>.generate(toppings.length, (index) => false),
            numberToAdd: 1,
            totalPrice: state.selectedFood!.price,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      } else {
        emit(ErrorState(
            selectedFood: state.selectedFood!,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      }
    }
  }

  void _mapUpdateProduct(
      UpdateProduct event, Emitter<ProductDetailState> emit) {
    if (state is InitState || state is ErrorState) {
      try {
        Food selectedProduct = FoodAPI()
            .currentFoods
            .firstWhere((element) => element.id == state.selectedFood!.id);

        List<Size> sizes = [];
        for (var size in SizeApi().currentSizes) {
          if (selectedProduct.sizes.contains(size.id) &&
              !state.bannedSize.contains(size.id)) {
            sizes.add(size);
          }
        }

        List<Topping> toppings = [];
        for (var topping in ToppingApi().currentToppings) {
          if (selectedProduct.toppings.contains(topping.id) &&
              !state.bannedTopping.contains(topping.id)) {
            toppings.add(topping);
          }
        }

        if (sizes.isNotEmpty) {
          emit(LoadedState(
              selectedFood: selectedProduct,
              productsSize: sizes,
              productsTopping: toppings,
              selectedSize: sizes[0],
              selectedToppings:
                  List<bool>.generate(toppings.length, (index) => false),
              numberToAdd: 1,
              totalPrice: state.selectedFood!.price,
              bannedSize: state.bannedSize,
              bannedTopping: state.bannedTopping));
        } else {
          emit(ErrorState(
              selectedFood: selectedProduct,
              bannedSize: state.bannedSize,
              bannedTopping: state.bannedTopping));
        }
      } catch (e) {
        emit(ErrorState(
            selectedFood: state.selectedFood!,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      }
    } else if (state is LoadedState) {
      try {
        Food food = FoodAPI()
            .currentFoods
            .firstWhere((element) => element.id == state.selectedFood!.id);

        List<Size> sizes = [];
        for (var size in SizeApi().currentSizes) {
          if (food.sizes.contains(size.id) &&
              !state.bannedSize.contains(size.id)) {
            sizes.add(size);
          }
        }

        List<Topping> toppings = [];
        for (var topping in ToppingApi().currentToppings) {
          if (food.toppings.contains(topping.id) &&
              !state.bannedTopping.contains(topping.id)) {
            toppings.add(topping);
          }
        }

        if (sizes.isNotEmpty) {
          emit(LoadedState(
              selectedFood: food,
              productsSize: sizes,
              productsTopping: toppings,
              selectedSize: sizes[0],
              selectedToppings:
                  List<bool>.generate(toppings.length, (index) => false),
              numberToAdd: 1,
              totalPrice: state.selectedFood!.price,
              bannedSize: state.bannedSize,
              bannedTopping: state.bannedTopping));
        } else {
          emit(ErrorState(
              selectedFood: state.selectedFood,
              bannedSize: state.bannedSize,
              bannedTopping: state.bannedTopping));
        }
      } catch (e) {
        emit(ErrorState(
            selectedFood: state.selectedFood,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      }
    }
  }

  void _mapUpdateSize(UpdateSize event, Emitter<ProductDetailState> emit) {
    if (state is InitState || state is ErrorState) {
      Food selectedProduct = state.selectedFood!;

      List<Size> sizes = [];
      for (var size in SizeApi().currentSizes) {
        if (selectedProduct.sizes.contains(size.id) &&
            !state.bannedSize.contains(size.id)) {
          sizes.add(size);
        }
      }

      List<Topping> toppings = [];
      for (var topping in ToppingApi().currentToppings) {
        if (selectedProduct.toppings.contains(topping.id) &&
            !state.bannedTopping.contains(topping.id)) {
          toppings.add(topping);
        }
      }

      if (sizes.isNotEmpty) {
        emit(LoadedState(
            selectedFood: state.selectedFood,
            productsSize: sizes,
            productsTopping: toppings,
            selectedSize: sizes[0],
            selectedToppings:
                List<bool>.generate(toppings.length, (index) => false),
            numberToAdd: 1,
            totalPrice: state.selectedFood!.price,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      } else {
        emit(ErrorState(
            selectedFood: state.selectedFood,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      }
    } else if (state is LoadedState) {
      List<Size> sizes = [];
      for (var size in SizeApi().currentSizes) {
        if (state.selectedFood!.sizes.contains(size.id) &&
            !state.bannedSize.contains(size.id)) {
          sizes.add(size);
        }
      }

      if (sizes.isNotEmpty) {
        emit(LoadedState(
            selectedFood: state.selectedFood,
            productsSize: sizes,
            productsTopping: (state as LoadedState).productsTopping,
            selectedSize: sizes[0],
            selectedToppings: List<bool>.generate(
                (state as LoadedState).productsTopping.length,
                (index) => false),
            numberToAdd: 1,
            totalPrice: state.selectedFood!.price,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      } else {
        emit(ErrorState(
            selectedFood: state.selectedFood,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      }
    }
  }

  void _mapUpdateTopping(
      UpdateTopping event, Emitter<ProductDetailState> emit) {
    if (state is InitState || state is ErrorState) {
      Food selectedProduct = state.selectedFood!;

      List<Size> sizes = [];
      for (var size in SizeApi().currentSizes) {
        if (selectedProduct.sizes.contains(size.id) &&
            !state.bannedSize.contains(size.id)) {
          sizes.add(size);
        }
      }

      List<Topping> toppings = [];
      for (var topping in ToppingApi().currentToppings) {
        if (selectedProduct.toppings.contains(topping.id) &&
            !state.bannedTopping.contains(topping.id)) {
          toppings.add(topping);
        }
      }

      if (sizes.isNotEmpty) {
        emit(LoadedState(
            selectedFood: state.selectedFood,
            productsSize: sizes,
            productsTopping: toppings,
            selectedSize: sizes[0],
            selectedToppings:
                List<bool>.generate(toppings.length, (index) => false),
            numberToAdd: 1,
            totalPrice: state.selectedFood!.price,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      } else {
        emit(ErrorState(
            selectedFood: state.selectedFood,
            bannedSize: state.bannedSize,
            bannedTopping: state.bannedTopping));
      }
    } else if (state is LoadedState) {
      List<Topping> toppings = [];
      for (var topping in ToppingApi().currentToppings) {
        if (state.selectedFood!.toppings.contains(topping.id) &&
            !state.bannedTopping.contains(topping.id)) {
          toppings.add(topping);
        }
      }

      emit(LoadedState(
          selectedFood: state.selectedFood,
          productsSize: (state as LoadedState).productsSize,
          productsTopping: toppings,
          selectedSize: (state as LoadedState).productsSize[0],
          selectedToppings:
              List<bool>.generate(toppings.length, (index) => false),
          numberToAdd: 1,
          totalPrice: state.selectedFood!.price,
          bannedSize: state.bannedSize,
          bannedTopping: state.bannedTopping));
    }
  }

  void _mapDecreaseAmount(
      DecreaseAmount event, Emitter<ProductDetailState> emit) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      emit(LoadedState(
          selectedFood: loadedState.selectedFood,
          selectedSize: loadedState.selectedSize,
          selectedToppings: loadedState.selectedToppings,
          numberToAdd: loadedState.numberToAdd - 1,
          totalPrice: loadedState.totalPrice,
          bannedSize: state.bannedSize,
          bannedTopping: state.bannedTopping,
          productsSize: loadedState.productsSize,
          productsTopping: loadedState.productsTopping));
    }
  }

  void _mapIncreaseAmount(
      IncreaseAmount event, Emitter<ProductDetailState> emit) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      emit(LoadedState(
          selectedFood: loadedState.selectedFood,
          selectedSize: loadedState.selectedSize,
          selectedToppings: loadedState.selectedToppings,
          numberToAdd: loadedState.numberToAdd + 1,
          totalPrice: loadedState.totalPrice,
          bannedSize: state.bannedSize,
          bannedTopping: state.bannedTopping,
          productsSize: loadedState.productsSize,
          productsTopping: loadedState.productsTopping));
    }
  }

  void _mapSelectSize(SelectSize event, Emitter<ProductDetailState> emit) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      double total = loadedState.totalPrice -
          loadedState.selectedSize.price +
          event.selectedSize.price;
      emit(LoadedState(
          selectedFood: loadedState.selectedFood,
          selectedSize: event.selectedSize,
          selectedToppings: loadedState.selectedToppings,
          numberToAdd: loadedState.numberToAdd,
          totalPrice: total,
          bannedSize: state.bannedSize,
          bannedTopping: state.bannedTopping,
          productsSize: loadedState.productsSize,
          productsTopping: loadedState.productsTopping));
    }
  }

  void _mapSelectTopping(
      SelectTopping event, Emitter<ProductDetailState> emit) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;

      loadedState.selectedToppings[event.index] = !loadedState.selectedToppings[event.index];

      emit(LoadedState(
          selectedFood: loadedState.selectedFood,
          selectedSize: loadedState.selectedSize,
          selectedToppings: loadedState.selectedToppings,
          numberToAdd: loadedState.numberToAdd,
          totalPrice: loadedState.totalPrice,
          bannedSize: state.bannedSize,
          bannedTopping: state.bannedTopping,
          productsSize: loadedState.productsSize,
          productsTopping: loadedState.productsTopping));
    }
  }

  void _mapSelectToppingWithValue(
      SelectToppingWithValue event, Emitter<ProductDetailState> emit) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;

      loadedState.selectedToppings[event.index] = event.value;

      emit(LoadedState(
          selectedFood: loadedState.selectedFood,
          selectedSize: loadedState.selectedSize,
          selectedToppings: loadedState.selectedToppings,
          numberToAdd: loadedState.numberToAdd,
          totalPrice: loadedState.totalPrice,
          bannedSize: state.bannedSize,
          bannedTopping: state.bannedTopping,
          productsSize: loadedState.productsSize,
          productsTopping: loadedState.productsTopping));
    }
  }

  @override
  Future<void> close() {
    _foodStoreSubscription?.cancel();
    _toppingStoreSubscription?.cancel();
    _sizeStoreSubscription?.cancel();
    return super.close();
  }
}
