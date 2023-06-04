import 'dart:async';

import 'package:coffee_shop_app/services/apis/store_api.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/constants/dimension.dart';
import '../../functions/calculate_distance.dart';
import '../../models/store.dart';

class StoreStoreBloc extends Bloc<StoreStoreEvent, StoreStoreState> {
  StreamSubscription<List<Store>>? _storeSubscription;
  StoreStoreBloc() : super(LoadingState(initStores: [], selectedStore: null)) {
    on<FetchData>(_mapFetchData);
    on<UpdateFavorite>(_mapUpdateFavorite);
    on<GetDataFetched>(_mapGetDataFetched);
  }

  void _mapFetchData(FetchData event, Emitter<StoreStoreState> emit) {
    emit(LoadingState(initStores: [], selectedStore: null));
    _storeSubscription?.cancel();
    _storeSubscription =
        StoreAPI().fetchData(event.location).listen((listStore) {
      add(GetDataFetched(allStores: listStore, latLng: event.location));
    }, onError: (_) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
      add(GetDataFetched(allStores: [], latLng: event.location));
    });
  }

  Future<void> _mapGetDataFetched(
      GetDataFetched event, Emitter<StoreStoreState> emit) async {
    List<Store> initStores = event.allStores;
    LatLng? location = event.latLng;

    emit(LoadingState(
        initStores: state.initStores, selectedStore: state.selectedStore));

    sortStore(initStores, location);

    Map<String, dynamic> storeObject =
        _separateIntoNeededObject(initStores, location);

    Store? nearestStore = storeObject["nearestStore"];
    List<Store> favoriteStores = storeObject["listFavoriteStore"];
    List<Store> otherStores = storeObject["listOtherStore"];

    //update SelectedStore
    Store? storeUpdated = state.selectedStore;
    if (state.selectedStore != null) {
      try {
        storeUpdated = initStores
            .firstWhere((element) => element.id == state.selectedStore!.id);
      } catch (e) {
        //Db has this store has been deleted
        storeUpdated = null;
      }
    } else {
      if (initStores.isNotEmpty) {
        storeUpdated = initStores.first;
      }
    }

    emit(FetchedState(
      initStores: initStores,
      latLng: location,
      nearestStore: nearestStore,
      listFavoriteStore: favoriteStores,
      listOtherStore: otherStores,
      selectedStore: storeUpdated,
    ));
  }

  Future<void> _mapUpdateFavorite(
      UpdateFavorite event, Emitter<StoreStoreState> emit) async {
    if (state is HasDataStoreStoreState) {
      LatLng? location = (state as HasDataStoreStoreState).latLng;
      Store? nearestStore = (state as HasDataStoreStoreState).nearestStore;
      List<Store> prevFavStores =
          (state as HasDataStoreStoreState).listFavoriteStore;
      List<Store> prevOtherStores =
          (state as HasDataStoreStoreState).listOtherStore;

      event.store.isFavorite = !event.store.isFavorite;

      emit(LoadingState(
          initStores: state.initStores, selectedStore: state.selectedStore));

      _storeSubscription?.pause();
      if (await StoreAPI().updateFavorite(event.store.id)) {
        Map<String, dynamic> storeObject =
            _separateIntoNeededObject(state.initStores, location);

        Store? nearestStore = storeObject["nearestStore"];
        List<Store> favoriteStores = storeObject["listFavoriteStore"];
        List<Store> otherStores = storeObject["listOtherStore"];

        //emit LoadedState
        emit(LoadedState(
          initStores: state.initStores,
          latLng: location,
          nearestStore: nearestStore,
          listFavoriteStore: favoriteStores,
          listOtherStore: otherStores,
          selectedStore: state.selectedStore,
        ));
      } else {
        event.store.isFavorite = !event.store.isFavorite;
        Fluttertoast.showToast(
            msg: "Đã có lỗi xảy ra, hãy thử lại sau.",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: Dimension.font14);
        emit(LoadedState(
          initStores: state.initStores,
          latLng: location,
          nearestStore: nearestStore,
          listFavoriteStore: prevFavStores,
          listOtherStore: prevOtherStores,
          selectedStore: state.selectedStore,
        ));
      }
      if (_storeSubscription?.isPaused ?? false) {
        _storeSubscription!.resume();
      }
    }
  }

  Map<String, dynamic> _separateIntoNeededObject(
      List<Store> stores, LatLng? location) {
    Store? nearestStore;
    List<Store> favoriteStores = [];
    List<Store> otherStores = [];

    int i = 0;
    if (stores.isNotEmpty && location != null) {
      double distanceNearestStore = calculateDistance(stores.first.address.lat,
          stores.first.address.lng, location.latitude, location.longitude);
      if (distanceNearestStore < 15) {
        nearestStore = stores.first;
        i = 1;
      }
    }

    for (; i < stores.length; i++) {
      Store store = stores[i];
      if (store.isFavorite) {
        favoriteStores.add(store);
      } else {
        otherStores.add(store);
      }
    }
    return {
      "nearestStore": nearestStore,
      "listFavoriteStore": favoriteStores,
      "listOtherStore": otherStores,
    };
  }

  void sortStore(List<Store> stores, LatLng? location) {
    if (location != null) {
      stores.sort((a, b) {
        double distanceA = 0, distanceB = 0;

        distanceA = calculateDistance(a.address.lat, a.address.lng,
            location.latitude, location.longitude);
        distanceB = calculateDistance(b.address.lat, b.address.lng,
            location.latitude, location.longitude);

        return distanceA.compareTo(distanceB);
      });
    }
  }

  @override
  Future<void> close() {
    _storeSubscription?.cancel();
    return super.close();
  }
}
