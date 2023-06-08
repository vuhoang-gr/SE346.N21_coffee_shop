import 'package:coffee_shop_app/routing/app_router.dart';
import 'package:coffee_shop_app/screens/auth/auth_screen.dart';
import 'package:coffee_shop_app/screens/loading/loading_screen.dart';
import 'package:coffee_shop_app/screens/loading/splash_screen.dart';
import 'package:coffee_shop_app/screens/main_page.dart';
import 'package:coffee_shop_app/screens/profile/image_view_screen.dart';
import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_event.dart'
    as address_event;
import 'package:coffee_shop_app/services/blocs/app_cubit/app_cubit.dart';
import 'package:coffee_shop_app/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_app/services/blocs/auth_action/auth_action_cubit.dart';
import 'package:coffee_shop_app/services/blocs/cart_cubit/cart_cubit.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_app/services/blocs/map_picker/map_picker_bloc.dart';
import 'package:coffee_shop_app/services/blocs/order/order_delivery_cubit.dart';
import 'package:coffee_shop_app/services/blocs/pickup_timer/pickup_timer_cubit.dart';
import 'package:coffee_shop_app/services/blocs/product_detail/product_detail_bloc.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_event.dart'
    as promo_event;
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/size_store/size_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/size_store/size_store_event.dart'
    as size_event;
import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_event.dart'
    as store_event;
import 'package:coffee_shop_app/services/blocs/topping_store/topping_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/topping_store/topping_store_event.dart'
    as topping_event;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  initLatLng = await _determineUserCurrentPosition();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isRmb = prefs.getBool('isRemember') ?? false;

  if (!isRmb) {
    AuthAPI().signOut();
  }
  bool isOpened = true;
  runApp(MyApp(
    isOpened: isOpened,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.isOpened});
  bool isOpened;

  @override
  Widget build(BuildContext context) {
    bool isDialogOpen = false;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ToppingStoreBloc>(
          create: (BuildContext context) =>
              ToppingStoreBloc()..add(topping_event.FetchData()),
        ),
        BlocProvider<SizeStoreBloc>(
          create: (BuildContext context) =>
              SizeStoreBloc()..add(size_event.FetchData()),
        ),
        BlocProvider<SearchProductBloc>(
          create: (BuildContext context) => SearchProductBloc(),
        ),
        BlocProvider<SearchStoreBloc>(
          create: (BuildContext context) => SearchStoreBloc(),
        ),
        BlocProvider<AddressStoreBloc>(
          create: (BuildContext context) =>
              AddressStoreBloc()..add(address_event.FetchData()),
        ),
        BlocProvider<ProductStoreBloc>(
          create: (BuildContext context) => ProductStoreBloc(),
        ),
        BlocProvider<CartButtonBloc>(
          create: (BuildContext context) =>
              CartButtonBloc(context.read<ProductStoreBloc>()),
        ),
        BlocProvider<StoreStoreBloc>(
          create: (BuildContext context) =>
              StoreStoreBloc(context.read<CartButtonBloc>())
                ..add(store_event.FetchData(location: initLatLng)),
        ),
        BlocProvider<RecentSeeProductsBloc>(
          create: (BuildContext context) =>
              RecentSeeProductsBloc(context.read<ProductStoreBloc>()),
        ),
        BlocProvider<EditAddressBloc>(
          create: (BuildContext context) => EditAddressBloc(),
        ),
        BlocProvider<TimerCubit>(
          create: (BuildContext context) => TimerCubit(),
        ),
        BlocProvider<MapPickerBloc>(
          create: (BuildContext context) => MapPickerBloc(),
        ),
        BlocProvider<PromoStoreBloc>(
          create: (BuildContext context) =>
              PromoStoreBloc()..add(promo_event.FetchData()),
        ),
        BlocProvider<ProductDetailBloc>(
          create: (BuildContext context) => ProductDetailBloc(
              productStoreBloc: context.read<ProductStoreBloc>(),
              sizeStoreBloc: context.read<SizeStoreBloc>(),
              toppingStoreBloc: context.read<ToppingStoreBloc>()),
        ),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<OrderDeliveryCubit>(
          create: (BuildContext context) => OrderDeliveryCubit(),
        ),
        BlocProvider<CartCubit>(
          create: (BuildContext context) => CartCubit(
              productStoreBloc: context.read<ProductStoreBloc>(),
              sizeStoreBloc: context.read<SizeStoreBloc>(),
              toppingStoreBloc: context.read<ToppingStoreBloc>()),
        ),
        BlocProvider<AppCubit>(create: (context) => AppCubit())
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          var appState = context.read<AppCubit>().state;

          FirebaseAuth.instance.userChanges().listen((User? user) async {
            AuthAPI.currentUser = await AuthAPI().toUser(user);
            if (context.mounted && isOpened) {
              isOpened = false;
              context
                  .read<AuthBloc>()
                  .add(UserChanged(user: AuthAPI.currentUser));
            }
          });
          // print(state);
          return MaterialApp(
              title: 'Coffee Shop',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: "Inter",
              ),
              home: MultiBlocListener(
                listeners: [
                  BlocListener<AppCubit, AppState>(
                    listener: (context, state) {
                      if (state is AppLoading) {
                        isDialogOpen = true;
                        showDialog(
                                context: context,
                                builder: (context) => LoadingScreen())
                            .then((value) => isDialogOpen = false);
                      } else if (state is AppLoaded && isDialogOpen) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
                child: state is Authenticated
                    ? MainPage()
                    : state is Loading
                        ? SplashScreen()
                        : BlocProvider<AuthActionCubit>(
                            create: (context) => AuthActionCubit(),
                            child: AuthScreen(),
                          ),
              ),
              // home: LoadingScreen(),
              onGenerateRoute: AppRouter(authState: state).onGenerateRoute);
        },
      ),
    );
  }
}
