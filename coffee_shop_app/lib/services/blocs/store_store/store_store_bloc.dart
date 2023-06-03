import 'dart:async';

import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/services/apis/store_api.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../functions/calculate_distance.dart';
import '../../models/store.dart';

class StoreStoreBloc extends Bloc<StoreStoreEvent, StoreStoreState> {
  StoreStoreBloc()
      : super(StoreAPI.currentStores == null
            ? LoadingState()
            : FetchedState(
                initStores: StoreAPI.currentStores!, latLng: initLatLng)) {
    on<FetchData>(_mapFetchData);
    on<UpdateFavorite>(_mapUpdateFavorite);
    on<ChangeFetchedToLoaded>(_mapChangeFetchedToLoaded);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<StoreStoreState> emit) async {
    emit(LoadingState());

    List<Store> fetchedData = await StoreAPI().fetchData(event.location);

    StoreAPI.currentStores = fetchedData;
    
    Store? nearestStore;
    List<Store> favoriteStores = [];
    List<Store> otherStores = [];

    int i = 0;
    if (fetchedData.isNotEmpty && event.location != null) {
      double distanceNearestStore = calculateDistance(
          fetchedData.first.address.lat,
          fetchedData.first.address.lng,
          event.location!.latitude,
          event.location!.longitude);
      if (distanceNearestStore < 15) {
        nearestStore = fetchedData.first;
        i = 1;
      }
    }

    for (; i < fetchedData.length; i++) {
      Store store = fetchedData[i];
      if (store.isFavorite) {
        favoriteStores.add(store);
      } else {
        otherStores.add(store);
      }
    }

    emit(LoadedState(
      initStores: fetchedData,
      latLng: event.location,
      nearestStore: nearestStore,
      listFavoriteStore: favoriteStores,
      listOtherStore: otherStores,
    ));
  }

  Future<void> _mapChangeFetchedToLoaded(
      ChangeFetchedToLoaded event, Emitter<StoreStoreState> emit) async {
    if (state is FetchedState) {
      List<Store> initStores = (state as FetchedState).initStores;
      LatLng? location = (state as FetchedState).latLng;

      emit(LoadingState());

      Map<String, dynamic> storeObject =
          _separateIntoNeededObject(initStores, location);

      Store? nearestStore = storeObject["nearestStore"];
      List<Store> favoriteStores = storeObject["listFavoriteStore"];
      List<Store> otherStores = storeObject["listOtherStore"];

      emit(LoadedState(
        initStores: initStores,
        latLng: location,
        nearestStore: nearestStore,
        listFavoriteStore: favoriteStores,
        listOtherStore: otherStores,
      ));
    }
  }

  Future<void> _mapUpdateFavorite(
      UpdateFavorite event, Emitter<StoreStoreState> emit) async {
    if (state is LoadedState) {
      List<Store> initStores = (state as LoadedState).initStores;
      LatLng? location = (state as LoadedState).latLng;

      emit(LoadingState());

      //update favorite
      event.store.isFavorite = !event.store.isFavorite;

      Map<String, dynamic> storeObject =
          _separateIntoNeededObject(initStores, location);

      Store? nearestStore = storeObject["nearestStore"];
      List<Store> favoriteStores = storeObject["listFavoriteStore"];
      List<Store> otherStores = storeObject["listOtherStore"];

      //emit LoadedState
      emit(LoadedState(
        initStores: initStores,
        latLng: location,
        nearestStore: nearestStore,
        listFavoriteStore: favoriteStores,
        listOtherStore: otherStores,
      ));
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
}
