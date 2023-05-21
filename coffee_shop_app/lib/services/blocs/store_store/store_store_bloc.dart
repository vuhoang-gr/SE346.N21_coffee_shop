import 'dart:async';

import 'package:coffee_shop_app/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_state.dart';
import 'package:coffee_shop_app/temp/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../functions/calculate_distance.dart';
import '../../models/store.dart';

class StoreStoreBloc extends Bloc<StoreStoreEvent, StoreStoreState> {
  StoreStoreBloc() : super(LoadingState(initStore: [], latLng: null)) {
    on<FetchData>(_mapFetchData);
    on<UpdateFavorite>(_mapUpdateFavorite);
  }

  Future<void> _mapFetchData(
      FetchData event, Emitter<StoreStoreState> emit) async {
    emit(LoadingState(initStore: state.initStore, latLng: state.latLng));
    await Future.delayed(const Duration(seconds: 1), () {
      //tempListStore will get all the store in the db
      List<Store> tempListStore = Data.stores;

      if (event.location != null) {
        tempListStore.sort((a, b) {
          double distanceA = 0, distanceB = 0;

          if (event.location != null) {
            distanceA = calculateDistance(a.address.lat, a.address.lng,
                event.location!.latitude, event.location!.longitude);
            distanceB = calculateDistance(b.address.lat, b.address.lng,
                event.location!.latitude, event.location!.longitude);
          }

          return distanceA.compareTo(distanceB);
        });
      }

      Store? nearestStore;
      List<Store> favoriteStores = [];
      List<Store> otherStores = [];

      int i = 0;
      if (tempListStore.isNotEmpty && event.location != null) {
        double distanceNearestStore = calculateDistance(
            tempListStore.first.address.lat,
            tempListStore.first.address.lng,
            event.location!.latitude,
            event.location!.longitude);
        if (distanceNearestStore < 15) {
          nearestStore = tempListStore.first;
          i = 1;
        }
      }

      for (; i < tempListStore.length; i++) {
        Store store = tempListStore[i];
        if (store.isFavorite) {
          favoriteStores.add(store);
        } else {
          otherStores.add(store);
        }
      }

      emit(LoadedState(
        initStore: tempListStore,
        latLng: event.location,        
        nearestStore: nearestStore,
        listFavoriteStore: favoriteStores,
        listOtherStore: otherStores,
      ));
    });
  }

  Future<void> _mapUpdateFavorite(
      UpdateFavorite event, Emitter<StoreStoreState> emit) async {
    emit(LoadingState(initStore: state.initStore, latLng: state.latLng));

    //update favorite
    event.store.isFavorite = !event.store.isFavorite;

    Map<String, dynamic> storeObject = separateIntoNeededObject(state.latLng);

    Store nearestStore = storeObject["nearestStore"];
    List<Store> favoriteStores = storeObject["listFavoriteStore"];
    List<Store> otherStores = storeObject["listOtherStore"];

    //emit LoadedState
    emit(LoadedState(
      initStore: state.initStore,
      latLng: state.latLng,
      nearestStore: nearestStore,
      listFavoriteStore: favoriteStores,
      listOtherStore: otherStores,
    ));
  }

  Map<String, dynamic> separateIntoNeededObject(LatLng? location) {
    Store? nearestStore;
    List<Store> favoriteStores = [];
    List<Store> otherStores = [];

    int i = 0;
    if (state.initStore.isNotEmpty && location != null) {
      double distanceNearestStore = calculateDistance(
          state.initStore.first.address.lat,
          state.initStore.first.address.lng,
          location.latitude,
          location.longitude);
      if (distanceNearestStore < 15) {
        nearestStore = state.initStore.first;
        i = 1;
      }
    }

    for (; i < state.initStore.length; i++) {
      Store store = state.initStore[i];
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
