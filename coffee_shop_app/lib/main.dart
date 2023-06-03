import 'package:coffee_shop_app/routing/app_router.dart';
import 'package:coffee_shop_app/screens/auth/auth_screen.dart';
import 'package:coffee_shop_app/screens/main_page.dart';
import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/apis/food_api.dart';
import 'package:coffee_shop_app/services/apis/store_api.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_app/services/blocs/auth_action/auth_action_cubit.dart';
import 'package:coffee_shop_app/services/blocs/cart_cubit/cart_cubit.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_app/services/blocs/map_picker/map_picker_bloc.dart';
import 'package:coffee_shop_app/services/blocs/pickup_timer/pickup_timer_cubit.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_app/services/models/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'firebase_options.dart';

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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    AuthAPI.currentUser = await AuthAPI().toUser(user);
  });
  initLatLng = await _determineUserCurrentPosition();

  StoreAPI.currentStores = await StoreAPI().fetchData(initLatLng);

  if ((StoreAPI.currentStores?.length ?? 0) == 0) {
    FoodAPI.currentFoods = await FoodAPI().fetchData();
  } else {
    Store store = StoreAPI.currentStores![0];
    FoodAPI.currentFoods = await FoodAPI().fetchData(
        stateFood: store.stateFood, stateTopping: store.stateTopping);
  }

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
        BlocProvider<SearchStoreBloc>(
          create: (BuildContext context) => SearchStoreBloc(),
        ),
        BlocProvider<StoreStoreBloc>(
          create: (BuildContext context) => StoreStoreBloc(),
        ),
        BlocProvider<CartButtonBloc>(
          create: (BuildContext context) => CartButtonBloc(),
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
        BlocProvider<PromoStoreBloc>(
          create: (BuildContext context) => PromoStoreBloc(),
        ),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          print(state);
          return MaterialApp(
              title: 'Coffee Shop',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: "Inter",
              ),
              home: state is Authenticated
                  ? MainPage()
                  : BlocProvider<AuthActionCubit>(
                      create: (context) => AuthActionCubit(),
                      child: AuthScreen(),
                    ),
              onGenerateRoute: AppRouter(authState: state).onGenerateRoute);
        },
      ),
    );
  }
}