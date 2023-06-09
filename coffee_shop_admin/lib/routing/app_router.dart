import 'package:coffee_shop_admin/screens/auth/auth_screen.dart';
import 'package:coffee_shop_admin/screens/drink_manage/drink_create.dart';
import 'package:coffee_shop_admin/screens/drink_manage/drink_detail.dart';
import 'package:coffee_shop_admin/screens/drink_manage/drink_edit.dart';

import 'package:coffee_shop_admin/screens/drink_manage/size_create.dart';
import 'package:coffee_shop_admin/screens/drink_manage/size_detail.dart';
import 'package:coffee_shop_admin/screens/drink_manage/size_edit.dart';
import 'package:coffee_shop_admin/screens/drink_manage/topping_create.dart';
import 'package:coffee_shop_admin/screens/drink_manage/topping_detail.dart';
import 'package:coffee_shop_admin/screens/drink_manage/topping_edit.dart';

import 'package:coffee_shop_admin/screens/main_page.dart';
import 'package:coffee_shop_admin/screens/profile/profile_screen.dart';
import 'package:coffee_shop_admin/screens/profile/profile_setting_screen.dart';
import 'package:coffee_shop_admin/screens/promo/promo_create.dart';
import 'package:coffee_shop_admin/screens/promo/promo_edit.dart';
import 'package:coffee_shop_admin/screens/promo/promo_screen.dart';
import 'package:coffee_shop_admin/screens/store/store_detail.dart';
import 'package:coffee_shop_admin/screens/store/store_create.dart';
import 'package:coffee_shop_admin/screens/store/store_edit.dart';
import 'package:coffee_shop_admin/screens/store/store_screen.dart';
import 'package:coffee_shop_admin/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/services/models/store.dart';
import 'package:coffee_shop_admin/widgets/feature/store/store_address/map_screen.dart';
import 'package:coffee_shop_admin/screens/user/user_screen.dart';
import 'package:coffee_shop_admin/services/blocs/auth_action/auth_action_cubit.dart';
import 'package:coffee_shop_admin/services/models/address.dart';
import 'package:coffee_shop_admin/services/models/promo.dart';
import 'package:coffee_shop_admin/services/models/topping.dart';

import 'package:coffee_shop_admin/services/models/size.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
      case ProfileScreen.routeName:
        return _createRoute(ProfileScreen());

      case ProfileSettingScreen.routeName:
        return _createRoute(ProfileSettingScreen());

      case CreateDrinkScreen.routeName:
        return _createRoute(CreateDrinkScreen());
      case EditDrinkScreen.routeName:
        Drink drink = settings.arguments as Drink;
        return _createRoute(EditDrinkScreen(
          product: drink,
        ));

      case CreateToppingScreen.routeName:
        return _createRoute(CreateToppingScreen());

      case EditToppingScreen.routeName:
        Topping topping = settings.arguments as Topping;
        return _createRoute(EditToppingScreen(
          product: topping,
        ));

      case CreateSizeScreen.routeName:
        return _createRoute(CreateSizeScreen());
      case EditSizeScreen.routeName:
        Size size = settings.arguments as Size;
        return _createRoute(EditSizeScreen(
          product: size,
        ));

      case CreateStoreScreen.routeName:
        Address? deliveryAddress = settings.arguments as Address?;
        return _createRoute(CreateStoreScreen(
          deliveryAddress: deliveryAddress,
        ));
      case EditStoreScreen.routeName:
        Store store = settings.arguments as Store;
        return _createRoute(EditStoreScreen(
          storeAddress: Address(address: store.address, addressNote: "", nameReceiver: store.sb, phone: store.phone),
          store: store,
        ));

      case MapScreen.routeName:
        LatLng latLng = settings.arguments as LatLng;
        return _createRoute(MapScreen(
          latLng: latLng,
        ));

      case "/drink_detail_screen":
        Drink food = settings.arguments as Drink;
        return _createRoute(DrinkDetail(product: food));

      case "/topping_detail_screen":
        Topping topping = settings.arguments as Topping;
        return _createRoute(ToppingDetail(product: topping));

      case "/size_detail_screen":
        Size size = settings.arguments as Size;
        return _createRoute(SizeDetail(product: size));

      case "/store_detail":
        Store args = settings.arguments as Store;
        return _createRoute(StoreDetail(
          store: args,
        ));

      case PromoScreen.routeName:
        return _createRoute(PromoScreen());
      case CreatePromoScreen.routeName:
        List<String> existCodes = settings.arguments as List<String>;
        return _createRoute(CreatePromoScreen(existCodeList: existCodes));
      case EditPromoScreen.routeName:
        Promo promo = settings.arguments as Promo;
        return _createRoute(EditPromoScreen(promo: promo));

      case StoreScreen.routeName:
        Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        bool isPurposeForShowDetail = arguments['isPurposeForShowDetail'] ?? false;
        return _createRoute(StoreScreen(
          isPurposeForShowDetail: isPurposeForShowDetail,
        ));

      case UserScreen.routeName:
        return _createRoute(UserScreen());

      default:
        return _createRoute(MainPage());
    }
  }
}
