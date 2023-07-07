import 'dart:async';

import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_event.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_state.dart';
import 'package:coffee_shop_admin/services/models/size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SizeListBloc extends Bloc<SizeListEvent, SizeListState> {
  SizeListBloc() : super(LoadingState()) {
    on<FetchData>(_mapFetchData);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<SizeListState> emit) async {
    emit(LoadingState());

    final pro = await sizeReference.get();
    List<Size> sizeList = [];
    for (var doc in pro.docs) {
      var s = doc.data();
      sizeList.add(Size(
          id: doc.id,
          name: s["name"] ?? "Unamed Size",
          price: s["price"] * 1.0,
          image: s["image"] ??
              "https://www.shutterstock.com/image-vector/bubble-tea-on-spoon-add-260nw-1712622337.jpg"));
    }
    emit(LoadedState(
      sizeList: sizeList,
    ));
  }
}
