import 'package:coffee_shop_staff/screens/staff/food/product_listing.dart';
import 'package:coffee_shop_staff/services/blocs/product/product_bloc.dart';
import 'package:coffee_shop_staff/widgets/global/skeleton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/models/store_product.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../../../widgets/global/custom_app_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  static const String routeName = 'product_screen/';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                    'Sản phẩm',
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
                      text: 'Đồ uống',
                    ),
                    Tab(
                      text: 'Topping',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    //drink
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        List<StoreProduct> itemList = [];
                        if (state is ProductLoaded) {
                          itemList = state.drink;
                          return ProductListing(itemList: itemList);
                        }
                        return Skeleton();
                      },
                    ),
                    //topping
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        List<StoreProduct> itemList = [];
                        if (state is ProductLoaded) {
                          itemList = state.topping;
                          return ProductListing(itemList: itemList);
                        }
                        return Skeleton();
                      },
                    ),
                    //map order have delivery type
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
