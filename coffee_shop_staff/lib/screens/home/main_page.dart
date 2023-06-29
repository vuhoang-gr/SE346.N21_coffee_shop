import 'package:coffee_shop_staff/main.dart';
import 'package:coffee_shop_staff/screens/home/home_screen.dart';
import 'package:coffee_shop_staff/screens/profile/profile_screen.dart';
import 'package:coffee_shop_staff/screens/staff/food/product_screen.dart';
import 'package:coffee_shop_staff/screens/staff/order/order_screen.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../services/models/store_product.dart';
import '../../temp/mockData.dart';
import '../../utils/constants/dimension.dart';

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
        length: 3,
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
                          Icons.fastfood,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'Product',
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
                          Icons.shopping_cart_checkout,
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
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      //home page
                      ProductScreen(),

                      OrderScreen(),

                      //profile
                      ProfileScreen(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
