import 'package:coffee_shop_app/services/functions/datetime_to_pickup.dart';
import 'package:coffee_shop_app/services/models/order.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../services/functions/money_transfer.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/constants/string.dart';
import '../../widgets/feature/order_widgets/order_manage_product_item.dart';
import '../../widgets/feature/order_widgets/store_info_dialog.dart';
import '../../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../../widgets/global/container_card.dart';
import '../../widgets/global/custom_app_bar.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    bool isPickup = order.pickupTime != null;
    return ColoredBox(
        color: AppColors.backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  leading: Text(
                    'Đơn hàng',
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
                              if (order.status == orderDelivering) {
                                imgUrl = 'assets/images/img_delivering.png';
                              } else if (order.status == orderDelivered ||
                                  order.status == orderCompleted) {
                                imgUrl = 'assets/images/img_delivered.png';
                              } else if (order.status == orderProcessing) {
                                imgUrl = 'assets/images/img_received.png';
                              } else if (order.status == orderReadyForPickup) {
                                imgUrl =
                                    'assets/images/img_ready_for_pickup.png';
                              } else if (order.status == orderCancelled ||
                                  order.status == orderFailed) {
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
                                            order.status,
                                            style: AppText.style.boldBlack14,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return StoreInfoDialog(
                                                        store: order.store!,
                                                      );
                                                    });
                                              },
                                              child: Text('Liên hệ hỗ trợ',
                                                  style: AppText
                                                      .style.boldBlack14
                                                      .copyWith(
                                                          color: Colors.blue)))
                                        ],
                                      ),
                                      Builder(builder: (context) {
                                        if (isPickup &&
                                            order.status != orderProcessing) {
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
                                                  child: Text.rich(
                                                    TextSpan(
                                                      style:
                                                          AppText.style.regular,
                                                      children: <TextSpan>[
                                                        const TextSpan(
                                                            text:
                                                                'Đơn hàng sẽ tự động hoàn thành '),
                                                        TextSpan(
                                                          text: '2 tiếng',
                                                          style: AppText.style
                                                              .boldBlack14,
                                                        ),
                                                        const TextSpan(
                                                            text:
                                                                ' sau giờ đến lấy của bạn. Cửa hàng sẽ không chịu trách nhiệm về đơn hàng sau khoảng thời gian đó.'),
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
                                "Thông tin chung",
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
                                            '${order.id}',
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
                                            'Ngày đặt hàng',
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            datetimeToPickup(order.dateOrder),
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
                                "Thông tin vận chuyển",
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
                                      child: Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                isPickup
                                                    ? 'Cửa hàng mang đi'
                                                    : 'Từ cửa hàng',
                                                style: AppText.style.regular),
                                            SizedBox(
                                              height: Dimension.height4,
                                            ),
                                            Text(
                                                order.store!.address
                                                    .formattedAddress,
                                                style:
                                                    AppText.style.boldBlack14)
                                          ],
                                        ),
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
                                        Expanded(
                                          child: IconWidgetRow(
                                            icon: isPickup
                                                ? Icons.access_time_filled
                                                : Icons.location_pin,
                                            iconColor: isPickup
                                                ? AppColors.orangeColor
                                                : AppColors.greenColor,
                                            child: Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      isPickup
                                                          ? 'Thời gian mang đi'
                                                          : 'Đến',
                                                      style: AppText
                                                          .style.regular),
                                                  SizedBox(
                                                    height: Dimension.height4,
                                                  ),
                                                  Text(
                                                      isPickup
                                                          ? datetimeToPickup(
                                                              order.pickupTime!)
                                                          : order
                                                              .address!
                                                              .address
                                                              .formattedAddress,
                                                      style: AppText
                                                          .style.boldBlack14),
                                                  isPickup
                                                      ? const SizedBox.shrink()
                                                      : Text.rich(
                                                          TextSpan(
                                                            style: AppText.style
                                                                .regularGrey12,
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                  text: order
                                                                      .address!
                                                                      .nameReceiver),
                                                              TextSpan(
                                                                text: ' • ',
                                                                style: AppText
                                                                    .style
                                                                    .boldBlack14,
                                                              ),
                                                              TextSpan(
                                                                  text: order
                                                                      .address!
                                                                      .phone),
                                                            ],
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
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
                                "Chi tiết đơn hàng",
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
                                            return OrderManageProductItem(
                                              orderItem: order.products[index],
                                            );
                                          },
                                          separatorBuilder: (_, __) =>
                                              const Divider(
                                                color: AppColors.greyBoxColor,
                                                thickness: 1,
                                              ),
                                          itemCount: order.products.length),
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
                                "Thanh toán",
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
                                            "Tổng tiền",
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            "${MoneyTransfer.transferFromDouble(order.totalProduct!)} ₫",
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                      isPickup
                                          ? SizedBox.shrink()
                                          : SizedBox(
                                              height: Dimension.height16,
                                            ),
                                      //shipping fee
                                      isPickup
                                          ? SizedBox.shrink()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Phí giao hàng",
                                                  style: AppText.style.regular,
                                                ),
                                                Text(
                                                  "${MoneyTransfer.transferFromDouble(order.deliveryCost!)} ₫",
                                                  style:
                                                      AppText.style.boldBlack14,
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
                                            "Giảm giá từ cửa hàng",
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            "-${MoneyTransfer.transferFromDouble(order.discount!)} ₫",
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
                                            'Thành tiền',
                                            style: AppText.style.regular,
                                          ),
                                          Text(
                                            "${MoneyTransfer.transferFromDouble(order.total!)} ₫",
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
