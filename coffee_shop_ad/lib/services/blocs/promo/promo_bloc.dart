import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_event.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_state.dart';
import 'package:coffee_shop_admin/services/models/promo.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  PromoBloc() : super(LoadingState(initPromos: [], listExistCode: [], stores: [], drinks: [])) {
    on<FetchData>(_mapFetchData);
  }

  void _mapFetchData(FetchData event, Emitter<PromoState> emit) async {
    emit(LoadingState(initPromos: [], listExistCode: [], stores: [], drinks: []));
    try {
      final CollectionReference promoReference = FirebaseFirestore.instance.collection('Promo');
      final promoDocs = await promoReference.get();
      List<Promo> promoList = [];
      List<String> existCodeList = [];
      promoDocs.docs.forEach((doc) {
        var curPromo = fromFireStore(doc.data() as Map<String, dynamic>?, doc.id);
        if (curPromo is Promo) {
          existCodeList.add(curPromo.id);
          promoList.add(curPromo);
        }
      });
      emit(LoadedState(initPromos: promoList, listExistCode: existCodeList, stores: [], drinks: []));
    } catch (_) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      emit(LoadedState(initPromos: [], listExistCode: [], stores: [], drinks: []));
    }
  }

  Promo? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;

    return Promo(
        id: id,
        minPrice: data['minPrice'].toDouble(),
        maxPrice: data['maxPrice'].toDouble(),
        percent: data['percent'].toDouble(),
        description: data['description'],
        dateEnd: data['dateEnd'].toDate(),
        dateStart: data['dateStart'].toDate(),
        products: data['products'].cast<String>(),
        stores: data['stores'].cast<String>(),
        forNewCustomer: data['forNewCustomer']);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
