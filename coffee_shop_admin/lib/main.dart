import 'package:coffee_shop_admin/routing/app_router.dart';
import 'package:coffee_shop_admin/screens/auth/auth_screen.dart';
import 'package:coffee_shop_admin/screens/loading/loading_screen.dart';
import 'package:coffee_shop_admin/screens/loading/splash_screen.dart';
import 'package:coffee_shop_admin/screens/main_page.dart';
import 'package:coffee_shop_admin/services/apis/auth_api.dart';
import 'package:coffee_shop_admin/services/blocs/address_store/address_store_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/app_cubit/app_cubit.dart';
import 'package:coffee_shop_admin/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/auth_action/auth_action_cubit.dart';
import 'package:coffee_shop_admin/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/map_picker/map_picker_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_event.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/user/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key, this.isOpened = true});
  bool isOpened = true;

  @override
  Widget build(BuildContext context) {
    bool isDialogOpen = false;

    return MultiBlocProvider(
      providers: [
        BlocProvider<DrinkListBloc>(
          create: (BuildContext context) => DrinkListBloc(),
        ),
        BlocProvider<ToppingListBloc>(
          create: (BuildContext context) => ToppingListBloc(),
        ),
        BlocProvider<SizeListBloc>(
          create: (BuildContext context) => SizeListBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc(),
        ),
        BlocProvider<StoreStoreBloc>(
          create: (BuildContext context) => StoreStoreBloc(),
        ),
        BlocProvider<PromoBloc>(
          create: (BuildContext context) => PromoBloc()..add(FetchData()),
        ),
        BlocProvider<EditAddressBloc>(
          create: (BuildContext context) => EditAddressBloc(),
        ),
        BlocProvider<AddressStoreBloc>(
          create: (BuildContext context) => AddressStoreBloc(),
        ),
        BlocProvider<MapPickerBloc>(
          create: (BuildContext context) => MapPickerBloc(),
        ),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<AppCubit>(create: (context) => AppCubit())
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          FirebaseAuth.instance.userChanges().listen((User? user) async {
            AuthAPI.currentUser = await AuthAPI().toUser(user);
            if (context.mounted && isOpened) {
              isOpened = false;
              context.read<AuthBloc>().add(UserChanged(user: AuthAPI.currentUser));
            }
          });
          // print(state);
          return MaterialApp(
              title: 'Coffee Shop Admin',
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
                        showDialog(context: context, builder: (context) => LoadingScreen())
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


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   FirebaseAuth.instance.authStateChanges().listen((User? user) async {
//     AuthAPI.currentUser = await AuthAPI().toUser(user);
//   });

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<DrinkListBloc>(
//           create: (BuildContext context) => DrinkListBloc(),
//         ),
//         BlocProvider<ToppingListBloc>(
//           create: (BuildContext context) => ToppingListBloc(),
//         ),
//         BlocProvider<SizeListBloc>(
//           create: (BuildContext context) => SizeListBloc(),
//         ),
//         BlocProvider<UserBloc>(
//           create: (BuildContext context) => UserBloc(),
//         ),
//         BlocProvider<StoreStoreBloc>(
//           create: (BuildContext context) => StoreStoreBloc(),
//         ),
//         BlocProvider<PromoBloc>(
//           create: (BuildContext context) => PromoBloc()..add(FetchData()),
//         ),
//         BlocProvider<EditAddressBloc>(
//           create: (BuildContext context) => EditAddressBloc(),
//         ),
//         BlocProvider<AddressStoreBloc>(
//           create: (BuildContext context) => AddressStoreBloc(),
//         ),
//         BlocProvider<MapPickerBloc>(
//           create: (BuildContext context) => MapPickerBloc(),
//         ),
//         BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
//       ],
//       child: BlocBuilder<AuthBloc, AuthState>(
//         builder: (context, state) {
//           print(state);
//           return MaterialApp(
//               title: 'Coffee Shop',
//               theme: ThemeData(
//                 primarySwatch: Colors.blue,
//                 fontFamily: "Inter",
//               ),
//               home: state is Authenticated
//                   ? MainPage()
//                   : BlocProvider<AuthActionCubit>(
//                       create: (context) => AuthActionCubit(),
//                       child: AuthScreen(),
//                     ),
//               onGenerateRoute: AppRouter(authState: state).onGenerateRoute);
//         },
//       ),
//     );
//   }
// }
