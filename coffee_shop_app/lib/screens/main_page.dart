import 'package:coffee_shop_app/screens/cart_delivery.dart';
import 'package:coffee_shop_app/screens/delivery_menu_screen.dart';
import 'package:coffee_shop_app/screens/home/home_screen.dart';
import 'package:coffee_shop_app/screens/order_detail_screen.dart';
import 'package:coffee_shop_app/screens/order_management/order_management.dart';
import 'package:coffee_shop_app/screens/product_detail.dart';
import 'package:coffee_shop_app/screens/store_list_screen.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../utils/constants/dimension.dart';
import '../utils/constants/string.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor,
      child: DefaultTabController(
        length: 5,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Container(
              height: Dimension.height56,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top:
                          BorderSide(color: AppColors.greyBoxColor, width: 1))),
              child: TabBar(
                indicator: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.blue, width: 1.5))),
                labelColor: Colors.blue,
                labelStyle: AppText.style.boldBlack14,
                unselectedLabelColor: AppColors.greyTextColor,
                unselectedLabelStyle: AppText.style.regular,
                tabs: [
                  Tab(
                    height: Dimension.height56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'Home',
                          style: AppText.style.regularGrey10,
                        )
                      ],
                    ),
                  ),
                  Tab(
                    height: Dimension.height56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.coffee_outlined,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'Menu',
                          style: AppText.style.regularGrey10,
                        )
                      ],
                    ),
                  ),
                  Tab(
                    height: Dimension.height56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'Stores',
                          style: AppText.style.regularGrey10,
                        )
                      ],
                    ),
                  ),
                  Tab(
                    height: Dimension.height56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.feed_outlined,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'Order',
                          style: AppText.style.regularGrey10,
                        )
                      ],
                    ),
                  ),
                  Tab(
                    height: Dimension.height56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'Profile',
                          style: AppText.style.regularGrey10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: TabBarView(
                  children: [
                    //home page
                    HomeScreen(),

                    //menu
                    DeliveryMenuScreen(),

                    //stores page
                    StoreListScreen(),

                    //order
                    OrderManagement(),

                    //profile
                    ProductDetail(),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}