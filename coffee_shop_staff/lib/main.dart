import 'package:coffee_shop_admin/screens/auth/auth_screen.dart';
import 'package:coffee_shop_admin/screens/profile/profile_screen.dart';
import 'package:coffee_shop_admin/screens/profile/profile_setting_screen.dart';
import 'package:coffee_shop_admin/screens/staff/food/product_screen.dart';
import 'package:coffee_shop_admin/screens/staff/order/order_detail_screen.dart';
import 'package:coffee_shop_admin/screens/staff/order/order_screen.dart';
import 'package:coffee_shop_admin/services/blocs/auth_cubit/auth_cubit.dart';
import 'package:coffee_shop_admin/temp/mockData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/screens.dart';
import 'services/models/store_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Inter",
      ),
      // home: OrderDetailScreen(
      //   order: FakeData.orderMock,
      // ),
      // home: ProductScreen(
      //   itemList: List.generate(
      //     15,
      //     (index) => StoreProduct(
      //         item: FakeData.toppingMock,
      //         isStocking: index % 2 == 1,
      //         store: FakeData.storeMock),
      //   ),
      // ),
      home: BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(),
        child: ProfileScreen(),
      ),
    );
  }
}
