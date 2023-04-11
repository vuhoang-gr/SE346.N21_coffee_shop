import 'package:coffee_shop_admin/services/models/food.dart';
import 'package:coffee_shop_admin/services/models/store_product.dart';
import 'package:coffee_shop_admin/temp/mockData.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../../../widgets/features/product_screen/product_card.dart';
import '../../../widgets/global/custom_app_bar.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key, required this.itemList});
  List<StoreProduct> itemList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            SizedBox(
              height: Dimension.height56,
              child: CustomAppBar(
                leading: Text(
                  itemList[0].item is Food ? 'Products' : 'Topping',
                  style: TextStyle(
                      fontSize: Dimension.height18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
