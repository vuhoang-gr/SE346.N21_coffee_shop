import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/screens/home/home_screen.dart';
import 'package:coffee_shop_app/screens/menu/menu_screen.dart';
import 'package:coffee_shop_app/screens/order_management/order_management.dart';
import 'package:coffee_shop_app/screens/profile/profile_screen.dart';
import 'package:coffee_shop_app/screens/store/store_selection_screen.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../utils/constants/dimension.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.selectedPage = 0});
  final int selectedPage;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor,
      child: DefaultTabController(
        initialIndex: widget.selectedPage,
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
                          style: AppText.style.regular10,
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
                          style: AppText.style.regular10,
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
                          style: AppText.style.regular10,
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
                          style: AppText.style.regular10,
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
                          style: AppText.style.regular10,
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
                    MenuScreen(),

                    //stores page
                    StoreSelectionScreen(latLng: initLatLng, isPurposeForShowDetail: true,),

                    //order
                    OrderManagement(),

                    //profile
                    ProfileScreen(),
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
