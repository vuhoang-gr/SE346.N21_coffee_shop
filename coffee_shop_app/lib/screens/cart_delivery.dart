import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants/dimension.dart';
import '../utils/styles/button.dart';
import '../widgets/feature/cart_delivery_pickup/apply_coupon_textfield.dart';
import '../widgets/feature/cart_delivery_pickup/checkout_prod_item.dart';
import '../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../widgets/global/container_card.dart';
import '../widgets/global/custom_app_bar.dart';

class CartDelivery extends StatefulWidget {
  const CartDelivery({super.key});

  @override
  State<CartDelivery> createState() => _CartDeliveryState();
}

class _CartDeliveryState extends State<CartDelivery> {
  bool isApplying = false;

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return ColoredBox(
      color: AppColors.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                leading: Text(
                  'Cart',
                  style: TextStyle(
                      fontSize: Dimension.height18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimension.height16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Dimension.height16,
                          ),
                          Text(
                            'Shipping details',
                            style: AppText.style.boldBlack16,
                          ),
                          SizedBox(
                            height: Dimension.height8,
                          ),

                          //from store to address
                          ContainerCard(
                            horizontalPadding: Dimension.height16,
                            verticalPadding: Dimension.height12 * 2,
                            child: Column(
                              children: [
                                IconWidgetRow(
                                  icon: Icons.store_rounded,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'From store',
                                        style: AppText.style.regular,
                                      ),
                                      SizedBox(
                                        height: Dimension.height8 / 2,
                                      ),
                                      Text(
                                        '13 Han Thuyen, D.1, HCM city',
                                        style: AppText.style.boldBlack14,
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: AppColors.greyBoxColor,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconWidgetRow(
                                      icon: Icons.location_pin,
                                      iconColor: AppColors.greenColor,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('To',
                                              style: AppText.style.regular),
                                          SizedBox(
                                            height: Dimension.height4,
                                          ),
                                          Text('285 CMT8, D.10, HCM city',
                                              style: AppText.style.boldBlack14),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  fontSize: Dimension.height12,
                                                  height: 1.5,
                                                  color:
                                                      AppColors.greyTextColor),
                                              children: <TextSpan>[
                                                const TextSpan(text: 'Nick'),
                                                TextSpan(
                                                    text: ' • ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Dimension.font14)),
                                                const TextSpan(
                                                    text: '0969696969'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        CupertinoIcons.right_chevron,
                                        size: Dimension.height20,
                                        color: AppColors.greyTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimension.height16,
                          ),

                          //oder details
                          Text(
                            'Order details',
                            style: AppText.style.boldBlack16,
                          ),
                          SizedBox(
                            height: Dimension.height8,
                          ),

                          ContainerCard(
                            horizontalPadding: Dimension.height16,
                            child: Column(
                              children: [
                                ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    controller: ScrollController(),
                                    itemBuilder: (context, index) {
                                      return CheckoutProdItem();
                                    },
                                    separatorBuilder: (_, __) => const Divider(
                                          thickness: 1,
                                          color: AppColors.greyBoxColor,
                                        ),
                                    itemCount: 3),
                                const Divider(
                                  thickness: 1,
                                  color: AppColors.greyBoxColor,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Price',
                                      style: TextStyle(
                                          fontSize: Dimension.font14,
                                          height: 1.5),
                                    ),
                                    Text(
                                      '319.000 ₫',
                                      style: AppText.style.boldBlack14,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimension.height16,
                ),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isApplying ? 8 : 0),
                      topRight: Radius.circular(isApplying ? 8 : 0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    //apply coupon
                    !isApplying
                        ? SizedBox(
                            height: Dimension.height40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconWidgetRow(
                                    icon: Icons.discount_rounded,
                                    iconColor: AppColors.greenColor,
                                    size: Dimension.height12 * 2,
                                    child: Text(
                                      'Apply coupon',
                                      style: AppText.style.boldBlack14,
                                    )),
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.right_chevron,
                                    size: Dimension.height20,
                                    color: AppColors.greyTextColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isApplying = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),

                    isApplying
                        ? ApplyCouponTextfield(
                            closeBox: () {
                              setState(() {
                                isApplying = false;
                              });
                            },
                          )
                        : const SizedBox(),

                    !isApplying
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimension.height8),
                            child: SizedBox(
                              width: double.maxFinite,
                              height: Dimension.height40,
                              child: ElevatedButton(
                                style: roundedButton,
                                onPressed: () {},
                                child: Text(
                                  'Pay 319.000 ₫',
                                  style: TextStyle(
                                      fontSize: Dimension.height16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
