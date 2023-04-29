import 'package:coffee_shop_app/screens/search_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../temp/data.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/feature/component_menu_screen/pickup_store_picker.dart';
import '../../widgets/global/cart_button.dart';
import '../../widgets/global/custom_app_bar.dart';
import '../../widgets/global/product_item.dart';

class PickupMenuScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  PickupMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          CustomAppBar(
            leading: Text(
              "Store pickup",
              style: AppText.style.boldBlack18,
            ),
            trailing: GestureDetector(
              onTap: ()=>Navigator.of(context).pushNamed(SearchProductScreen.routeName),
              child: Icon(
                CupertinoIcons.search
              ),
            )
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white),
              child: Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    children: [
                      const PickupStorePicker(),
                      SizedBox(height: Dimension.height8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                        child: Text(
                          "Favorite",
                          style: AppText.style.mediumBlack14,
                        ),
                      ),
                      ...(Data.favoriteProducts
                          .map((e) => Container(
                                padding: EdgeInsets.only(
                                    bottom: Dimension.height8,
                                    left: Dimension.width16,
                                    right: Dimension.width16),
                                child: (ProductItem(
                                  id: e.id,
                                  productName: e.name,
                                  productPrice: e.price,
                                  dateRegister: DateTime(2023, 3, 15, 12, 12),
                                  imageProduct: e.images[0],
                                )),
                              ))
                          .toList()),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                        child: Text(
                          "All",
                          style: AppText.style.mediumBlack14,
                        ),
                      ),
                      ...(Data.products
                          .map((e) => Container(
                                padding: EdgeInsets.only(
                                    bottom: Dimension.height8,
                                    left: Dimension.width16,
                                    right: Dimension.width16),
                                child: (ProductItem(
                                  id: e.id,
                                  productName: e.name,
                                  productPrice: e.price,
                                  dateRegister: DateTime(2023, 3, 27, 12, 12),
                                  imageProduct: e.images[0],
                                )),
                              ))
                          .toList()),
                      SizedBox(
                        height: Dimension.height68,
                      )
                    ],
                  ),
                  CartButton(scrollController: _scrollController)
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
