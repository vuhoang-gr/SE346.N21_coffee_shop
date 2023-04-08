import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../utils/constants/dimension.dart';
import '../utils/constants/string.dart';
import '../widgets/feature/order_widgets/order_manage_product_item.dart';
import '../widgets/feature/order_widgets/store_info_dialog.dart';
import '../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../widgets/global/container_card.dart';
import '../widgets/global/custom_app_bar.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, this.orderStatus = 'Preparing'});
  final String orderStatus;
  @override
  Widget build(BuildContext context) {
    bool isPickup;
    if (orderStatus == orderReceived ||
        orderStatus == orderReadyForPickup ||
        orderStatus == orderCompleted) {
      isPickup = true;
    } else {
      isPickup = false;
    }
    return ColoredBox(
        color: AppColors.backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  leading: Text(
                    'Order  247-96024',
                    style: AppText.style.boldBlack18,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Builder(builder: (context) {
                              String imgUrl;
                              if (orderStatus == orderDelivering) {
                                imgUrl = 'assets/images/img_delivering.png';
                              } else if (orderStatus == orderDelivered ||
                                  orderStatus == orderCompleted) {
                                imgUrl = 'assets/images/img_delivered.png';
                              } else if (orderStatus == orderReceived) {
                                imgUrl = 'assets/images/img_received.png';
                              } else if (orderStatus == orderReadyForPickup) {
                                imgUrl =
                                    'assets/images/img_ready_for_pickup.png';
                              } else if (orderStatus == orderDeliveryFailed) {
                                imgUrl =
                                    'assets/images/img_delivery_failed.png';
                              } else {
                                imgUrl = 'assets/images/img_preparing.png';
                              }
                              return Image.asset(
                                imgUrl,
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                              );
                            }),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: Dimension.height150 * 4 / 3,
                                    left: Dimension.height16,
                                    right: Dimension.height16),
                                child: ContainerCard(
                                  horizontalPadding: Dimension.height16,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Preparing',
                                            style: AppText.style.boldBlack14,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return StoreInfoDialog();
                                                    });
                                              },
                                              child: Text(
                                                'Contact support',
                                                style: AppText.style.boldBlack14
                                              ))
                                        ],
                                      ),
                                      Builder(builder: (context) {
                                        if (isPickup &&
                                            orderStatus != orderReceived) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                                bottom: Dimension.height8),
                                            padding: EdgeInsets.all(
                                                Dimension.height8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: AppColors
                                                        .greyTextField)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.info_outline,
                                                  color:
                                                      AppColors.greyTextColor,
                                                ),
                                                SizedBox(
                                                  width: Dimension.height10,
                                                ),
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style:
                                                          AppText.style.regular,
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                            text:
                                                                'Order will be automatically completed '),
                                                        TextSpan(
                                                          text: 'X hours',
                                                          style: AppText.style
                                                              .boldBlack14,
                                                        ),
                                                        const TextSpan(
                                                            text:
                                                                ' after your pick up time. The store won\'t be responsible for your order after that time.'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimension.height16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Dimension.height16,
                              ),

                              //General info
                              Text(
                                "General info",
                                style: AppText.style.boldBlack16,
                              ),
                              SizedBox(
                                height: Dimension.height8,
                              ),
                              ContainerCard(
                                  verticalPadding: Dimension.height24,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Order ID',
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            '247-96024',
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: AppColors.greyBoxColor,
                                        thickness: 1.5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Order date',
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            '20/04/2020, 04:20',
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                              //from store to address
                              SizedBox(
                                height: Dimension.height16,
                              ),
                              Text(
                                "Shipping details",
                                style: AppText.style.boldBlack16,
                              ),
                              SizedBox(
                                height: Dimension.height8,
                              ),

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
                                              isPickup
                                                  ? 'Pick up location'
                                                  : 'From store',
                                              style: AppText.style.regular),
                                          SizedBox(
                                            height: Dimension.height4,
                                          ),
                                          Text('13 Han Thuyen, D.1, HCM city',
                                              style: AppText.style.boldBlack14)
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
                                          icon: isPickup
                                              ? Icons.access_time_filled
                                              : Icons.location_pin,
                                          iconColor: isPickup
                                              ? AppColors.orangeColor
                                              : AppColors.greenColor,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  isPickup
                                                      ? 'Pick up time'
                                                      : 'To',
                                                  style: AppText.style.regular),
                                              SizedBox(
                                                height: Dimension.height4,
                                              ),
                                              Text('285 CMT8, D.10, HCM city',
                                                  style: AppText
                                                      .style.boldBlack14),
                                              isPickup
                                                  ? const SizedBox.shrink()
                                                  : RichText(
                                                      text: TextSpan(
                                                        style: AppText.style.regularGrey12,
                                                        children: <TextSpan>[
                                                          const TextSpan(
                                                              text: 'Nick'),
                                                          TextSpan(
                                                              text: ' • ',
                                                              style: AppText.style.boldBlack14,),
                                                          const TextSpan(
                                                              text:
                                                                  '0969696969'),
                                                        ],
                                                      ),
                                                    ),
                                            ],
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
                              //product info
                              Text(
                                "Product info",
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
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return const OrderManageProductItem();
                                          },
                                          separatorBuilder: (_, __) =>
                                              const Divider(
                                                color: AppColors.greyBoxColor,
                                                thickness: 1,
                                              ),
                                          itemCount: 2),
                                      SizedBox(
                                        height: Dimension.height24,
                                      )
                                    ],
                                  )),

                              SizedBox(
                                height: Dimension.height16,
                              ),
                              //product info
                              Text(
                                "Payment info",
                                style: AppText.style.boldBlack16,
                              ),
                              SizedBox(
                                height: Dimension.height8,
                              ),
                              ContainerCard(
                                  verticalPadding: Dimension.height24,
                                  horizontalPadding: Dimension.height16,
                                  child: Column(
                                    children: [
                                      //price
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Price",
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            "319.000 ₫",
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dimension.height16,
                                      ),
                                      //shipping fee
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Shipping fee",
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            "15.000 ₫",
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dimension.height16,
                                      ),
                                      //promotion
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Promotion",
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            "-50.000 ₫",
                                            style: AppText.style.boldBlack14
                                                .copyWith(
                                                    color:
                                                        AppColors.greenColor),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dimension.height16,
                                      ),
                                      //total
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total",
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            "248.000 ₫",
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: Dimension.height40,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
