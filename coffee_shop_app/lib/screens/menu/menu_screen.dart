import 'package:coffee_shop_app/screens/menu/delivery_menu_screen.dart';
import 'package:coffee_shop_app/screens/menu/pickup_menu_screen.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../services/blocs/cart_button/cart_button_state.dart';

class MenuScreen extends StatelessWidget {
  static const String routeName = "/menu_screen";
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartButtonBloc, CartButtonState>(
        builder: (context, state) {
      if (state.selectedOrderType == OrderType.delivery) {
        return DeliveryMenuScreen();
      } else {
        return PickupMenuScreen();
      }
    });
  }
}
