import 'package:coffee_shop_app/screens/address_listing_screen.dart';
import 'package:coffee_shop_app/screens/address_screen.dart';
import 'package:coffee_shop_app/screens/auth/auth_screen.dart';
import 'package:coffee_shop_app/screens/cart/cart_delivery.dart';
import 'package:coffee_shop_app/screens/cart/cart_store_pickup.dart';
import 'package:coffee_shop_app/screens/main_page.dart';
import 'package:coffee_shop_app/screens/menu/menu_screen.dart';
import 'package:coffee_shop_app/screens/product_detail.dart';
import 'package:coffee_shop_app/screens/profile/profile_screen.dart';
import 'package:coffee_shop_app/screens/profile/profile_setting_screen.dart';
import 'package:coffee_shop_app/screens/search_product_screen.dart';
import 'package:coffee_shop_app/screens/store_detail.dart';
import 'package:coffee_shop_app/screens/store_list_screen.dart';
import 'package:coffee_shop_app/screens/store_selection_screen.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../services/models/food.dart';
import '../services/models/store.dart';
import '../temp/data.dart';

class AppRouter {
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return _createRoute(HomeScreen());

      case "/auth_screen":
        return _createRoute(AuthScreen());

      case "/cart_delivery_screen":
        return _createRoute(CartDelivery());

      case "/cart_store_pickup_screen":
        return _createRoute(CartStorePickup());

      case "/profile_screen":
        return _createRoute(ProfileScreen());

      case "/profile_setting_screen":
        return _createRoute(ProfileSettingScreen());

      case AddressListingScreen.routeName:
        return _createRoute(AddressListingScreen());

      case AddressScreen.routeName:
        Map<String, dynamic>? arguments =
            settings.arguments as Map<String, dynamic>?;
        int position = arguments?['index'] ?? -1;
        DeliveryAddress? deliveryAddress = arguments?['deliveryAddress'];
        return _createRoute(AddressScreen(
          deliveryAddress: deliveryAddress,
          index: position,
        ));

      case MenuScreen.routeName:
        return _createRoute(MenuScreen());

      case "/product_detail_screen":
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        String id = arguments['id'] ?? '';
        Food food = Data.products.firstWhere((element) => element.id == id);
        return _createRoute(ProductDetail(product: food));

      case SearchProductScreen.routeName:
        return _createRoute(SearchProductScreen());

      case "/store_detail":
        Store args = settings.arguments as Store;
        return _createRoute(StoreDetail(
          store: args,
        ));

      case "/store_list_screen":
        return _createRoute(StoreListScreen());

      case StoreSelectionScreen.routeName:
        return _createRoute(StoreSelectionScreen());

      default:
        return _createRoute(MainPage());
    }
  }
}
