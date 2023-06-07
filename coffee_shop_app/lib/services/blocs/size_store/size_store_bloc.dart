import 'dart:async';

import 'package:coffee_shop_app/services/apis/size_api.dart';
import 'package:coffee_shop_app/services/blocs/size_store/size_store_event.dart';
import 'package:coffee_shop_app/services/blocs/size_store/size_store_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/constants/dimension.dart';
import '../../models/size.dart';

class SizeStoreBloc extends Bloc<SizeStoreEvent, SizeStoreState> {
  StreamSubscription<List<Size>>? _sizeStoreSubscription;
  SizeStoreBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
    on<GetDataFetched>(_mapGetDataFetched);
  }

  void _mapFetchData(FetchData event, Emitter<SizeStoreState> emit) {
    emit(LoadingState());
    _sizeStoreSubscription?.cancel();
    _sizeStoreSubscription = SizeApi().fetchData().listen((listSizes) {
      add(GetDataFetched(listSizes: listSizes));
    }, onError: (_) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      add(GetDataFetched(listSizes: []));
    });
  }

  void _mapGetDataFetched(GetDataFetched event, Emitter<SizeStoreState> emit) {
    emit(FetchedState());
    emit(LoadedState());
  }

  @override
  Future<void> close() {
    _sizeStoreSubscription?.cancel();
    return super.close();
  }
}
