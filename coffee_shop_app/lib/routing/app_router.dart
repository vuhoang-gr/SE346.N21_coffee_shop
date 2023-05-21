import 'package:coffee_shop_app/screens/customer_address/address_listing_screen.dart';
import 'package:coffee_shop_app/screens/customer_address/address_screen.dart';
import 'package:coffee_shop_app/screens/auth/auth_screen.dart';
import 'package:coffee_shop_app/screens/cart/cart_delivery.dart';
import 'package:coffee_shop_app/screens/cart/cart_store_pickup.dart';
import 'package:coffee_shop_app/screens/customer_address/map_screen.dart';
import 'package:coffee_shop_app/screens/main_page.dart';
import 'package:coffee_shop_app/screens/menu/menu_screen.dart';
import 'package:coffee_shop_app/screens/product_detail.dart';
import 'package:coffee_shop_app/screens/profile/profile_screen.dart';
import 'package:coffee_shop_app/screens/profile/profile_setting_screen.dart';
import 'package:coffee_shop_app/screens/search_product_screen.dart';
import 'package:coffee_shop_app/screens/store/store_detail.dart';
import 'package:coffee_shop_app/screens/store/store_search_screen.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/home/home_screen.dart';
import '../screens/store/store_selection_screen.dart';
import '../services/models/food.dart';
import '../services/models/store.dart';

class AppRouter {
  static Route _createRoute(Widget page) {
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

  static Route onGenerateRoute(RouteSettings settings) {
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
        DeliveryAddress? deliveryAddress =
            settings.arguments as DeliveryAddress?;
        return _createRoute(AddressScreen(
          deliveryAddress: deliveryAddress,
        ));

      case MapScreen.routeName:
        LatLng latLng = settings.arguments as LatLng;
        return _createRoute(MapScreen(
          latLng: latLng,
        ));

      case MenuScreen.routeName:
        return _createRoute(MenuScreen());

      case "/product_detail_screen":
        Food food =
            settings.arguments as Food;
        return _createRoute(ProductDetail(product: food));

      case SearchProductScreen.routeName:
        return _createRoute(SearchProductScreen());

      case "/store_detail":
        Store args = settings.arguments as Store;
        return _createRoute(StoreDetail(
          store: args,
        ));

      case StoreSelectionScreen.routeName:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        LatLng? location = arguments['latLng'];
        bool isPurposeForShowDetail =
            arguments['isPurposeForShowDetail'] ?? false;
        return _createRoute(StoreSelectionScreen(
          latLng: location,
          isPurposeForShowDetail: isPurposeForShowDetail,
        ));

      case StoreSearchScreen.routeName:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        LatLng? latLng = arguments['latLng'];
        bool isPurposeForShowDetail =
            arguments['isPurposeForShowDetail'] ?? false;
        return MaterialPageRoute(
            builder: ((context) => StoreSearchScreen(
                  latLng: latLng,
                  isPurposeForShowDetail: isPurposeForShowDetail,
                )));

      default:
        return _createRoute(MainPage());
    }
  }
}
