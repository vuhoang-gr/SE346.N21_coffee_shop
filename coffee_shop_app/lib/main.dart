import 'package:coffee_shop_app/routing/app_router.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_cubit/cart_cubit.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_app/services/blocs/map_picker/map_picker_bloc.dart';
import 'package:coffee_shop_app/services/blocs/pickup_timer/pickup_timer_cubit.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> _determineUserCurrentPosition() async {
  LocationPermission locationPermission;
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationServiceEnabled) {
    print("user don't enable location permission");
  }

  locationPermission = await Geolocator.checkPermission();

  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      print("user denied location permission");
    }
  }

  if (locationPermission == LocationPermission.deniedForever) {
    print("user denied permission forever");
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);

  return LatLng(position.latitude, position.longitude);
}

late LatLng? initLatLng;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLatLng = await _determineUserCurrentPosition();
  // Data.storeAddress.sort((a, b) {
  //   double distanceA = 0, distanceB = 0;
  //   if (initLatLng != null) {
  //     distanceA = calculateDistance(a.address.lat, a.address.lng,
  //         initLatLng!.latitude, initLatLng!.latitude);
  //     distanceB = calculateDistance(b.address.lat, b.address.lng,
  //         initLatLng!.latitude, initLatLng!.latitude);
  //   }
  //   bool isDistanceASmallerDistanceB = distanceA < distanceB;
  //   bool isAFavorite = a.isFavorite;
  //   bool isBFavorite = b.isFavorite;
  //   if ((distanceA <= 5 && distanceB <= 5) ||
  //       (distanceA > 5 && distanceB > 5)) {
  //     if (!isBFavorite && isAFavorite) {
  //       return -1;
  //     } else if (isBFavorite && isAFavorite) {
  //       return isDistanceASmallerDistanceB ? 1 : -1;
  //     }
  //   } else if (distanceA <= 5 && distanceB > 5) {
  //     return 1;
  //   } else if (distanceA > 5 && distanceB <= 5) {
  //     return -1;
  //   }
  //   return 1;
  // });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (BuildContext context) => CartCubit(),
        ),
        BlocProvider<SearchProductBloc>(
          create: (BuildContext context) => SearchProductBloc(),
        ),
        BlocProvider<ProductStoreBloc>(
          create: (BuildContext context) => ProductStoreBloc(),
        ),
        BlocProvider<CartButtonBloc>(
          create: (BuildContext context) => CartButtonBloc(),
        ),
        BlocProvider<SearchStoreBloc>(
          create: (BuildContext context) => SearchStoreBloc(),
        ),
        BlocProvider<StoreStoreBloc>(
          create: (BuildContext context) => StoreStoreBloc(),
        ),
        BlocProvider<RecentSeeProductsBloc>(
          create: (BuildContext context) => RecentSeeProductsBloc(),
        ),
        BlocProvider<EditAddressBloc>(
          create: (BuildContext context) => EditAddressBloc(),
        ),
        BlocProvider<AddressStoreBloc>(
          create: (BuildContext context) => AddressStoreBloc(),
        ),
        BlocProvider<TimerCubit>(
          create: (BuildContext context) => TimerCubit(),
        ),
        BlocProvider<MapPickerBloc>(
          create: (BuildContext context) => MapPickerBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Coffee Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Inter",
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
