import 'package:coffee_shop_app/screens/customer_address/address_listing_screen.dart';
import 'package:coffee_shop_app/screens/customer_address/address_screen.dart';
import 'package:coffee_shop_app/screens/auth/auth_screen.dart';
import 'package:coffee_shop_app/screens/cart/cart_delivery.dart';
import 'package:coffee_shop_app/screens/cart/cart_store_pickup.dart';
import 'package:coffee_shop_app/screens/customer_address/map_screen.dart';
import 'package:coffee_shop_app/screens/main_page.dart';
import 'package:coffee_shop_app/screens/menu/menu_screen.dart';
import 'package:coffee_shop_app/screens/order_management/order_detail_screen.dart';
import 'package:coffee_shop_app/screens/order_management/order_history.dart';
import 'package:coffee_shop_app/screens/product_detail.dart';
import 'package:coffee_shop_app/screens/profile/image_view_screen.dart';
import 'package:coffee_shop_app/screens/profile/profile_screen.dart';
import 'package:coffee_shop_app/screens/profile/profile_setting_screen.dart';
import 'package:coffee_shop_app/screens/promo/promo_qr_scan.dart';
import 'package:coffee_shop_app/screens/promo/promo_screen.dart';
import 'package:coffee_shop_app/screens/search_product_screen.dart';
import 'package:coffee_shop_app/screens/store/store_detail.dart';
import 'package:coffee_shop_app/screens/store/store_search_screen.dart';
import 'package:coffee_shop_app/services/blocs/auth_action/auth_action_cubit.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:coffee_shop_app/services/models/order.dart';
import 'package:coffee_shop_app/utils/constants/firestorage_bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/home/home_screen.dart';
import '../screens/store/store_selection_screen.dart';
import '../services/blocs/auth/auth_bloc.dart';
import '../services/models/store.dart';

class AppRouter {
  AuthState authState = UnAuthenticated();

  AppRouter({required this.authState});

  AuthActionCubit authActionCubit = AuthActionCubit();

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

  Route unAuthenticedRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: authActionCubit,
            child: AuthScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: authActionCubit,
            child: AuthScreen(),
          ),
        );
    }
  }

  Route onGenerateRoute(RouteSettings settings) {
    if (authState is UnAuthenticated) {
      return unAuthenticedRoute(settings);
    } else if (authState is Authenticated) {
      return authenticatedRoute(settings);
    } else {
      return unAuthenticedRoute(settings);
    }
  }

  Route authenticatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return _createRoute(HomeScreen());

      case "/cart_delivery_screen":
        return _createRoute(CartDelivery());

      case "/cart_store_pickup_screen":
        return _createRoute(CartStorePickup());

      case ProfileScreen.routeName:
        return _createRoute(ProfileScreen());

      case ProfileSettingScreen.routeName:
        return _createRoute(ProfileSettingScreen());

      case ImageViewScreen.routeName:
        Set<Object> args = settings.arguments as Set<Object>;
        String image = args.elementAt(0) as String;
        ImageStatus imageStatus = ImageStatus.view;
        BUCKET? bucket;
        Function? onSubmit;
        try {
          imageStatus = args.elementAt(1) as ImageStatus;
          bucket = args.elementAt(2) as BUCKET;
          onSubmit = args.elementAt(3) as Function;
        } catch (e) {
          print(e);
        }
        return _createRoute(ImageViewScreen(
          image: image,
          imgStatus: imageStatus,
          bucket: bucket,
          onSubmit: onSubmit,
        ));

      case AddressListingScreen.routeName:
        return _createRoute(AddressListingScreen());

      case AddressScreen.routeName:
        DeliveryAddress? deliveryAddress =
            settings.arguments as DeliveryAddress?;
        return _createRoute(AddressScreen(
          deliveryAddress: deliveryAddress,
        ));

      case MapScreen.routeName:
        LatLng? latLng = settings.arguments as LatLng?;
        return _createRoute(MapScreen(
          latLng: latLng,
        ));

      case MenuScreen.routeName:
        return _createRoute(MenuScreen());

      case "/product_detail_screen":
        return _createRoute(ProductDetail());
      case "/order_detail_screen":
        Order order = settings.arguments as Order;
        return _createRoute(OrderDetailScreen(
          order: order,
        ));
      case "/order_history":
        return _createRoute(OrderHistory());
      case SearchProductScreen.routeName:
        return _createRoute(SearchProductScreen());

      case StoreDetail.routeName:
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
      case PromoScreen.routeName:
        return _createRoute(PromoScreen());
      case PromoQRScan.routeName:
        return _createRoute(PromoQRScan());
      default:
        return _createRoute(MainPage());
    }
  }
}
