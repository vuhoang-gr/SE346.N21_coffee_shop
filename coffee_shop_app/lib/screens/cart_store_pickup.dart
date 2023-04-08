import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants/dimension.dart';
import '../utils/styles/button.dart';
import '../widgets/feature/cart_delivery_pickup/apply_coupon_textfield.dart';
import '../widgets/feature/cart_delivery_pickup/checkout_prod_item.dart';
import '../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../widgets/global/container_card.dart';
import '../widgets/global/custom_app_bar.dart';

class CartStorePickup extends StatefulWidget {
  const CartStorePickup({super.key});

  @override
  State<CartStorePickup> createState() => _CartStorePickupState();
}

class _CartStorePickupState extends State<CartStorePickup> {
  bool isApplying = false;
  bool isPickingTime = false;

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
                  style: AppText.style.boldBlack18
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
                            'Pickup details',
                            style: AppText.style.boldBlack16,
                          ),
                          SizedBox(
                            height: Dimension.height8,
                          ),

                          //from store to address
                          ContainerCard(
                            horizontalPadding: Dimension.height16,
                            verticalPadding: Dimension.height24,
                            child: Column(
                              children: [
                                IconWidgetRow(
                                  icon: Icons.location_pin,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pick up location',
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
                                      icon: Icons.access_time_filled_sharp,
                                      iconColor: AppColors.orangeColor,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pick up time',
                                            style: AppText.style.regular,
                                          ),
                                          SizedBox(
                                            height: Dimension.height4,
                                          ),
                                          Text(
                                            '10:00, Today',
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                    ),

                                    //time picking icon
                                    IconButton(
                                      icon: Icon(
                                        CupertinoIcons.right_chevron,
                                        size: Dimension.height20,
                                        color: AppColors.greyTextColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPickingTime = !isPickingTime;
                                        });
                                      },
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
                                      return const CheckoutProdItem();
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
                                      style: AppText.style.regularBlack14,
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
                      topLeft:
                          Radius.circular(isApplying || isPickingTime ? 8 : 0),
                      topRight:
                          Radius.circular(isApplying || isPickingTime ? 8 : 0)),
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
                    !isApplying && !isPickingTime
                        ? SizedBox(
                            height: Dimension.height40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconWidgetRow(
                                    icon: Icons.discount_rounded,
                                    iconColor: AppColors.greenColor,
                                    size: Dimension.height24,
                                    child: Text(
                                      'Apply coupon',
                                      style: AppText.style.boldBlack14,
                                    )),
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.right_chevron,
                                    size: Dimension.height40 / 2,
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

                    // pay button
                    !isApplying && !isPickingTime
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
                                  style: AppText.style.regularWhite16,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),

                    isPickingTime
                        ? Column(
                            children: [
                              SizedBox(
                                height: Dimension.height8,
                              ),
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          isPickingTime = false;
                                        });
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Pickup time',
                                      style: AppText.style.boldBlack16,
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                thickness: 1,
                                color: AppColors.greyBoxColor,
                              ),

                              //the time picker
                              SizedBox(
                                height: Dimension.heightTimePicker,
                                child: Stack(
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: double.maxFinite,
                                          height: Dimension.height24,
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: AppColors
                                                          .greyBoxColor,
                                                      width: 1),
                                                  bottom: BorderSide(
                                                      color: AppColors
                                                          .greyBoxColor,
                                                      width: 1))),
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child:
                                              ListWheelScrollView.useDelegate(
                                                  physics:
                                                      const FixedExtentScrollPhysics(),
                                                  itemExtent:
                                                      Dimension.height24,
                                                  childDelegate:
                                                      ListWheelChildBuilderDelegate(
                                                          childCount: 7,
                                                          builder:
                                                              (context, index) {
                                                            String day;
                                                            if (index == 0) {
                                                              day = 'Today';
                                                            } else if (index ==
                                                                1) {
                                                              day = 'Tomorrow';
                                                            } else {
                                                              day = DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format((DateTime
                                                                          .now()
                                                                      .add(Duration(
                                                                          days:
                                                                              index))))
                                                                  .toString();
                                                            }

                                                            return Center(
                                                              child: Text(
                                                                day,
                                                                style: AppText
                                                                    .style
                                                                    .boldBlack16,
                                                              ),
                                                            );
                                                          })),
                                        ),
                                        Expanded(
                                          child:
                                              ListWheelScrollView.useDelegate(
                                                  physics:
                                                      const FixedExtentScrollPhysics(),
                                                  itemExtent:
                                                      Dimension.height24,
                                                  childDelegate:
                                                      ListWheelChildBuilderDelegate(
                                                          childCount: 32,
                                                          builder:
                                                              (context, index) {
                                                            return Center(
                                                              child: Text(
                                                                indexToTime(
                                                                    index + 12),
                                                                style: AppText
                                                                    .style
                                                                    .boldBlack16,
                                                              ),
                                                            );
                                                          })),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: Dimension.height16,
                              ),
                              const Divider(
                                thickness: 1,
                                color: AppColors.greyBoxColor,
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                height: Dimension.height40,
                                child: ElevatedButton(
                                  style: roundedButton,
                                  onPressed: () {},
                                  child: Text(
                                    'Apply',
                                    style: AppText.style.regularWhite16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dimension.height8,
                              ),
                            ],
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

  String indexToTime(int index) {
    int hour = (index / 2).floor();
    return '${hour < 10 ? '0$hour' : hour}:${index % 2 * 30 == 0 ? '00' : index % 2 * 30}';
  }
}
