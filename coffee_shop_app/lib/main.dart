import 'package:coffee_shop_app/screens/address_listing_screen.dart';
import 'package:coffee_shop_app/screens/address_screen.dart';
import 'package:coffee_shop_app/screens/delivery_menu_screen.dart';
import 'package:coffee_shop_app/screens/home/home_screen.dart';
import 'package:coffee_shop_app/screens/pickup_menu_screen.dart';
import 'package:flutter/material.dart';

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
      initialRoute: "/",
      routes: {
        "/": (ctx) => const HomeScreen(),
        AddressListingScreen.routeName: (ctx) => const AddressListingScreen(),
        AddressScreen.routeName: (ctx) => const AddressScreen(),
        DeliveryMenuScreen.routeName: (ctx) => const DeliveryMenuScreen(),
        PickupMenuScreen.routeName: (ctx) => const PickupMenuScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen()
      },
    );
  }
}
