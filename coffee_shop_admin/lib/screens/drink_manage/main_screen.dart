import 'package:coffee_shop_admin/screens/drink_manage/drink_screen.dart';
import 'package:coffee_shop_admin/screens/drink_manage/size_screen.dart';
import 'package:coffee_shop_admin/screens/drink_manage/topping_screen.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DrinkManagement extends StatelessWidget {
  const DrinkManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            ColoredBox(
              color: Colors.white,
              child: SizedBox(
                height: Dimension.height56,
                child: CustomAppBar(
                  leading: Text(
                    'Products',
                    style: AppText.style.boldBlack18,
                  ),
                  // trailing: IconButton(
                  //     onPressed: () {},
                  //     icon: const FaIcon(FontAwesomeIcons.clockRotateLeft)),
                ),
              ),
            ),
            Container(
              height: Dimension.height45,
              decoration: const BoxDecoration(
                  color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.greyBoxColor, width: 1.5))),
              child: TabBar(
                indicator: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue, width: 1.5))),
                labelColor: Colors.blue,
                labelStyle: AppText.style.boldBlack14,
                unselectedLabelColor: AppColors.greyTextColor,
                unselectedLabelStyle: AppText.style.regular,
                tabs: const [
                  Tab(
                    text: 'Drink',
                  ),
                  Tab(
                    text: 'Topping',
                  ),
                  Tab(
                    text: 'Size',
                  ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              children: [
                DrinkScreen(),
                ToppingList(),
                SizeScreen(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
