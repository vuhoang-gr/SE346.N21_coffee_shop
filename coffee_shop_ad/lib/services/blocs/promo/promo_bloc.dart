import 'dart:async';

import 'package:coffee_shop_admin/services/apis/promo_api.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_event.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/constants/dimension.dart';
import '../../models/promo.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  StreamSubscription<List<Promo>>? _promoStoreSubscription;
  PromoBloc() : super(LoadingState(initPromos: [])) {
    on<FetchData>(_mapFetchData);
    on<GetDataFetched>(_mapGetDataFetched);
  }

  void _mapFetchData(FetchData event, Emitter<PromoState> emit) {
    emit(LoadingState(initPromos: []));
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

  void _mapGetDataFetched(GetDataFetched event, Emitter<PromoState> emit) {
    emit(LoadedState(initPromos: event.listPromos));
  }

  @override
  Future<void> close() {
    _promoStoreSubscription?.cancel();
    return super.close();
  }
}
