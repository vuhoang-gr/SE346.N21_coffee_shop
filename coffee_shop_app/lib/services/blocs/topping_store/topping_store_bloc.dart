import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/constants/dimension.dart';
import '../../apis/topping_api.dart';
import '../../models/topping.dart';
import '../topping_store/topping_store_event.dart';
import '../topping_store/topping_store_state.dart';

class ToppingStoreBloc extends Bloc<ToppingStoreEvent, ToppingStoreState> {
  StreamSubscription<List<Topping>>? _toppingStoreSubscription;
  ToppingStoreBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
    on<GetDataFetched>(_mapGetDataFetched);
  }

  void _mapFetchData(FetchData event, Emitter<ToppingStoreState> emit) {
    emit(LoadingState());
    _toppingStoreSubscription?.cancel();
    _toppingStoreSubscription = ToppingApi().fetchData().listen((listToppings) {
      add(GetDataFetched(listToppings: listToppings));
    }, onError: (_) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      add(GetDataFetched(listToppings: []));
    });
  }

  void _mapGetDataFetched(
      GetDataFetched event, Emitter<ToppingStoreState> emit) {
    emit(FetchedState());
    emit(LoadedState());
  }

  @override
  Future<void> close() {
    _toppingStoreSubscription?.cancel();
    return super.close();
  }
}
