import 'dart:async';

import 'package:coffee_shop_app/services/apis/promo_api.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_event.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/constants/dimension.dart';
import '../../models/promo.dart';

class PromoStoreBloc extends Bloc<PromoStoreEvent, PromoStoreState> {
  StreamSubscription<List<Promo>>? _promoStoreSubscription;
  PromoStoreBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
    on<GetDataFetched>(_mapGetDataFetched);
  }

  void _mapFetchData(FetchData event, Emitter<PromoStoreState> emit) {
    emit(LoadingState());
    _promoStoreSubscription?.cancel();
    _promoStoreSubscription = PromoAPI().fetchData().listen((listPromos) {
      add(GetDataFetched(listPromos: listPromos));
    }, onError: (_) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      add(GetDataFetched(listPromos: []));
    });
  }

  void _mapGetDataFetched(GetDataFetched event, Emitter<PromoStoreState> emit) {
    emit(LoadedState());
  }

  @override
  Future<void> close() {
    _promoStoreSubscription?.cancel();
    return super.close();
  }
}
