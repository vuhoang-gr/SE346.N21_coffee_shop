import 'package:coffee_shop_app/routing/app_router.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_cubit/cart_cubit.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

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
        BlocProvider<CartButtonBloc>(
          create: (BuildContext context) => CartButtonBloc(),
        ),
        BlocProvider<SearchStoreBloc>(
          create: (BuildContext context) => SearchStoreBloc(),
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
      ],
      child: MaterialApp(
        title: 'Coffee Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Inter",
        ),
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}
