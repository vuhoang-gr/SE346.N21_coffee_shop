import 'package:coffee_shop_staff/services/models/store_product.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../../../widgets/features/product_screen/product_card.dart';

// ignore: must_be_immutable
class ProductListing extends StatelessWidget {
  ProductListing({super.key, required this.itemList});
  List<StoreProduct> itemList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: itemList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: Dimension.height12,
                    );
                  },
                  itemCount: itemList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
