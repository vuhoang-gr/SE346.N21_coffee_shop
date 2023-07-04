import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_state.dart';
import 'package:coffee_shop_admin/services/models/location.dart';
import 'package:coffee_shop_admin/services/models/store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StoreStoreBloc extends Bloc<StoreStoreEvent, StoreStoreState> {
  StoreStoreBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
  }

  Future<void> _mapFetchData(FetchData event, Emitter<StoreStoreState> emit) async {
    final pro = await storeReference.get();
    List<Store> stores = [];
    for (var doc in pro.docs) {
      var s = doc.data();
      stores.add(Store(
        id: doc.id,
        sb: s["shortName"],
        address: MLocation(
            formattedAddress: s["address"]["formattedAddress"], lat: s["address"]["lat"], lng: s["address"]["lng"]),
        phone: s["phone"],
        images: s["images"],
        openTime: DateFormat('HH:mm').format((s["timeOpen"] as Timestamp).toDate()),
        closeTime: DateFormat('HH:mm').format((s["timeClose"] as Timestamp).toDate()),
      ));
    }
    await Future.delayed(const Duration(seconds: 1), () {
      emit(LoadedState(
        stores: stores,
      ));
    });
  }
}
