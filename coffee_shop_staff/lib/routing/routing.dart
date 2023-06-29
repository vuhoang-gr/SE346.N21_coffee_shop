import 'package:coffee_shop_staff/screens/profile/image_view_screen.dart';
import 'package:coffee_shop_staff/screens/staff/order/order_detail_screen.dart';
import 'package:coffee_shop_staff/services/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/main_page.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/profile_setting_screen.dart';
import '../services/blocs/auth/auth_bloc.dart';
import '../services/blocs/auth_action/auth_action_cubit.dart';
import '../utils/constants/firestorage_bucket.dart';

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
      case OrderDetailScreen.routeName:
        var arg = settings.arguments as Order;
        return _createRoute(OrderDetailScreen(order: arg));

      default:
        return _createRoute(MainPage());
    }
  }
}
