import 'package:coffee_shop_staff/routing/routing.dart';
import 'package:coffee_shop_staff/screens/auth/auth_screen.dart';
import 'package:coffee_shop_staff/screens/home/main_page.dart';
import 'package:coffee_shop_staff/screens/loading/loading_screen.dart';
import 'package:coffee_shop_staff/screens/loading/splash_screen.dart';
import 'package:coffee_shop_staff/services/apis/auth_api.dart';
import 'package:coffee_shop_staff/services/apis/store_api.dart';
import 'package:coffee_shop_staff/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_staff/services/blocs/auth_action/auth_action_cubit.dart';
import 'package:coffee_shop_staff/services/blocs/order/order_bloc.dart';
import 'package:coffee_shop_staff/services/blocs/product/product_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'services/blocs/app_cubit/app_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isRmb = prefs.getBool('isRemember') ?? false;

  if (!isRmb) {
    await AuthAPI().signOut();
  }
  bool isOpened = true;
  runApp(MyApp(
    isOpened: isOpened,
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key, required this.isOpened});
  bool isOpened;

  @override
  Widget build(BuildContext context) {
    bool isDialogOpen = false;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<AppCubit>(create: (context) => AppCubit()),
        BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
        BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          FirebaseAuth.instance.userChanges().listen((User? user) async {
            AuthAPI.currentUser = await AuthAPI().toUser(user);
            if (context.mounted && isOpened) {
              isOpened = false;
              context
                  .read<AuthBloc>()
                  .add(UserChanged(user: AuthAPI.currentUser));
            }
          });

          if (state is Authenticated) {
            context
                .read<ProductBloc>()
                .add(LoadProduct(storeID: StoreAPI.currentStore!.id));
            context.read<OrderBloc>().add(FetchOrder());
          }
          // print(state);
          return MaterialApp(
              title: 'Coffee Shop Staff',
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
