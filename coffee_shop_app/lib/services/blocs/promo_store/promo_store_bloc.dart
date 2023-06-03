import 'dart:async';

import 'package:coffee_shop_app/services/apis/promo_api.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_event.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/promo.dart';

class PromoStoreBloc extends Bloc<PromoStoreEvent, PromoStoreState> {
  PromoStoreBloc() : super(LoadingState(initPromos: [])) {
    on<FetchData>(_mapFetchData);
    on<UsePromo>(_mapUsePromo);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<PromoStoreState> emit) async {
    emit(LoadingState(initPromos: state.initPromos));

    List<Promo> promos = await PromoAPI().fetchData();

    emit(LoadedState(initPromos: promos));
  }

  Future<void> _mapUsePromo(
      UsePromo event, Emitter<PromoStoreState> emit) async {
    emit(LoadingState(initPromos: state.initPromos));

    //update favorite
    event.promo.numberUsed -= 1;

    emit(LoadedState(initPromos: state.initPromos));
  }
}