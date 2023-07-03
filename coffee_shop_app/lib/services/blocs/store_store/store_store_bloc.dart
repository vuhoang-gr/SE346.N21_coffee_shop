import 'dart:async';

import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/services/apis/store_api.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/constants/dimension.dart';
import '../../functions/calculate_distance.dart';
import '../../models/store.dart';

class StoreStoreBloc extends Bloc<StoreStoreEvent, StoreStoreState> {
  StreamSubscription<List<Store>>? _storeSubscription;
  final CartButtonBloc _cartButtonBloc;
  StoreStoreBloc(this._cartButtonBloc)
      : super(LoadingState(initStores: [], latLng: null)) {
    print('stateInit: storeStore............................................');
    on<FetchData>(_mapFetchData);
    on<UpdateFavorite>(_mapUpdateFavorite);
    on<UpdateLocation>(_mapUpdateLocation);
    on<GetDataFetched>(_mapGetDataFetched);

    FirebaseAuth.instance.authStateChanges().listen(userSubscriptionFunction);
  }
  void userSubscriptionFunction(User? user) {
    if (user != null) {
      add(FetchData(location: initLatLng));
    }
  }

  void _mapFetchData(FetchData event, Emitter<StoreStoreState> emit) {
    emit(LoadingState(initStores: state.initStores, latLng: state.latLng));
    _storeSubscription?.cancel();
    _storeSubscription = StoreAPI().fetchData().listen((listStore) {
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

  void _mapUpdateLocation(UpdateLocation event, Emitter<StoreStoreState> emit) {
    if ((event.latLng == null && state.latLng != null) ||
        (event.latLng != null && state.latLng == null) ||
        (event.latLng != null &&
            state.latLng != null &&
            event.latLng != state.latLng)) {
      emit(LoadingState(initStores: state.initStores, latLng: state.latLng));
      sortStore(state.initStores, event.latLng);
      Map<String, dynamic> storeObject =
          _separateIntoNeededObject(state.initStores, event.latLng);

      Store? nearestStore = storeObject["nearestStore"];
      List<Store> favoriteStores = storeObject["listFavoriteStore"];
      List<Store> otherStores = storeObject["listOtherStore"];
      emit(LoadedState(
        latLng: event.latLng,
        nearestStore: nearestStore,
        listFavoriteStore: favoriteStores,
        listOtherStore: otherStores,
        initStores: state.initStores,
      ));
    }
  }

  Future<void> _mapGetDataFetched(
      GetDataFetched event, Emitter<StoreStoreState> emit) async {
    List<Store> initStores = List.from(event.allStores);
    LatLng? location = event.latLng;

    emit(LoadingState(initStores: state.initStores, latLng: state.latLng));

    sortStore(initStores, location);

    Map<String, dynamic> storeObject =
        _separateIntoNeededObject(initStores, location);

    Store? nearestStore = storeObject["nearestStore"];
    List<Store> favoriteStores = storeObject["listFavoriteStore"];
    List<Store> otherStores = storeObject["listOtherStore"];

    //update SelectedStore
    Store? storeUpdated = _cartButtonBloc.state.selectedStore;
    if (storeUpdated != null) {
      try {
        storeUpdated =
            initStores.firstWhere((element) => element.id == storeUpdated!.id);
      } catch (e) {
        //Db has this store has been deleted
        storeUpdated = null;
      }
    } else {
      if (initStores.isNotEmpty) {
        storeUpdated = initStores.first;
      }
    }
    _cartButtonBloc.add(UpdateDataSelectedStore(selectedStore: storeUpdated));

    emit(FetchedState(
      latLng: location,
      nearestStore: nearestStore,
      listFavoriteStore: favoriteStores,
      listOtherStore: otherStores,
      initStores: initStores,
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

      emit(LoadingState(initStores: state.initStores, latLng: state.latLng));

      _storeSubscription?.pause();

      bool? isUpdateSuccess = await StoreAPI()
          .updateFavorite(event.store.id, event.store.isFavorite);
      if (isUpdateSuccess != null) {
        Map<String, dynamic> storeObject =
            _separateIntoNeededObject(state.initStores, location);

        Store? nearestStore = storeObject["nearestStore"];
        List<Store> favoriteStores = storeObject["listFavoriteStore"];
        List<Store> otherStores = storeObject["listOtherStore"];

        //emit LoadedState
        emit(LoadedState(
          latLng: location,
          nearestStore: nearestStore,
          listFavoriteStore: favoriteStores,
          listOtherStore: otherStores,
          initStores: state.initStores,
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
          latLng: location,
          nearestStore: nearestStore,
          listFavoriteStore: prevFavStores,
          listOtherStore: prevOtherStores,
          initStores: state.initStores,
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
    } else {
      stores.sort((a, b) {
        return a.sb.compareTo(b.sb);
      });
    }
  }

  @override
  Future<void> close() {
    _storeSubscription?.cancel();
    return super.close();
  }
}
