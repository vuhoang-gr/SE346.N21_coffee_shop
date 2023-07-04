import 'package:coffee_shop_admin/screens/drink_manage/main_screen.dart';

import 'package:coffee_shop_admin/screens/profile/profile_screen.dart';
import 'package:coffee_shop_admin/screens/promo/promo_screen.dart';
import 'package:coffee_shop_admin/screens/store/store_screen.dart';
import 'package:coffee_shop_admin/screens/user/user_screen.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
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
                  color: Colors.white, border: Border(top: BorderSide(color: AppColors.greyBoxColor, width: 1))),
              child: TabBar(
                indicator: const BoxDecoration(border: Border(top: BorderSide(color: Colors.blue, width: 1.5))),
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
                          Icons.coffee_outlined,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'Drink',
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
                          'Store',
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
                          Icons.ballot_outlined,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'Promo',
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
                          Icons.supervisor_account_outlined,
                          size: Dimension.font14 * 2,
                        ),
                        Text(
                          'User',
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
                    DrinkManagement(),
                    StoreScreen(),
                    PromoScreen(),
                    UserScreen(),
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
