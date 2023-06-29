import 'package:coffee_shop_staff/screens/staff/food/product_listing.dart';

import '../../../services/models/store_product.dart';
import '../../../temp/mockData.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../../../widgets/global/custom_app_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
                      text: 'Drink',
                    ),
                    Tab(
                      text: 'Topping',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    //store pickup
                    //map order have pickup type
                    ProductListing(
                        itemList: List.generate(
                            10,
                            (i) => StoreProduct(
                                isStocking: i % 2 == 0,
                                store: FakeData.storeMock,
                                item: FakeData.toppingMock))),

                    //delivery
                    //map order have delivery type
                    ProductListing(
                        itemList: List.generate(
                            10,
                            (i) => StoreProduct(
                                isStocking: i % 2 == 0,
                                store: FakeData.storeMock,
                                item: FakeData.foodMock))),
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
