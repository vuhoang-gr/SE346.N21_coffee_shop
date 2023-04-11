import 'package:coffee_shop_app/screens/search_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../temp/data.dart';
import '../utils/colors/app_colors.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../widgets/feature/component_menu_screen/address_picker.dart';
import '../widgets/feature/component_menu_screen/delivery_store_picker.dart';
import '../widgets/global/custom_app_bar.dart';
import '../widgets/global/product_item.dart';

class DeliveryMenuScreen extends StatefulWidget {
  static String routeName = "/delivery_menu_screen";

  const DeliveryMenuScreen({super.key});

  @override
  State<DeliveryMenuScreen> createState() => _DeliveryMenuScreenState();
}

class _DeliveryMenuScreenState extends State<DeliveryMenuScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.offset <= Dimension.height86 && _isButtonVisible) {
        setState(() {
          _isButtonVisible = false;
        });
      } else if (_scrollController.offset > Dimension.height86 &&
          !_isButtonVisible) {
        setState(() {
          _isButtonVisible = true;
        });
      }
    });

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
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
            child: Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  children: [
                    AddressPicker(),
                    SizedBox(height: Dimension.height8),
                    const DeliveryStorePicker(),
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
                  ],
                ),
                _isButtonVisible
                    ? Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: Dimension.height8,
                            ),
                            color: Colors.white,
                            child: const DeliveryStorePicker()))
                    : Container()
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: !_isButtonVisible
          ? null
          : CircleAvatar(
              radius: Dimension.height20,
              backgroundColor: AppColors.blackSuperblurColor,
              child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const FaIcon(
                    FontAwesomeIcons.chevronUp,
                    color: AppColors.greyTextColor,
                  ),
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }),
            ),
    ));
  }
}
