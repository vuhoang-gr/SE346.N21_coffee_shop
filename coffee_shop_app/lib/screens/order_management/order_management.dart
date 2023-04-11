import 'package:coffee_shop_app/screens/order_management/pickup_management.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants/dimension.dart';
import '../../widgets/global/custom_app_bar.dart';
import 'delivery_management.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            ColoredBox(
              color: Colors.white,
              child: SizedBox(
                height: Dimension.height56,
                child: CustomAppBar(
                  leading: Text(
                    'Orders',
                    style: AppText.style.boldBlack18,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.clockRotateLeft)),
                ),
              ),
            ),
            Container(
              height: Dimension.height45,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          color: AppColors.greyBoxColor, width: 1.5))),
              child: TabBar(
                indicator: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.blue, width: 1.5))),
                labelColor: Colors.blue,
                labelStyle: AppText.style.boldBlack14,
                unselectedLabelColor: AppColors.greyTextColor,
                unselectedLabelStyle: AppText.style.regular,
                tabs: const [
                  Tab(
                    text: 'Store pickup',
                  ),
                  Tab(
                    text: 'Delivery',
                  ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              children: [
                //store pickup
                PickupManagement(),

                //delivery
                DeliveryManagement(
                  hasOrder: true,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
