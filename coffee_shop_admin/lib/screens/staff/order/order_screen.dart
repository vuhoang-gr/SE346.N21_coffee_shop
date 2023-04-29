import 'package:coffee_shop_admin/utils/constants/order_enum.dart';

import '../../../temp/mockData.dart';
import 'order_listing.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../../../widgets/global/custom_app_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              SizedBox(
                height: Dimension.height56,
                child: CustomAppBar(
                  leading: Text(
                    'Orders',
                    style: TextStyle(
                        fontSize: Dimension.height18,
                        fontWeight: FontWeight.bold),
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
                    //map order have pickup type
                    OrderListing(
                      orderList: List.generate(5, (index) {
                        return FakeData.orderMock;
                      }),
                    ),

                    //delivery
                    //map order have delivery type
                    OrderListing(
                      orderList: List.generate(5, (index) {
                        return FakeData.orderMock;
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}