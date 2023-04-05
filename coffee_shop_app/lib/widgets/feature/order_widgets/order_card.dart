import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/widgets/feature/order_widgets/order_status_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../utils/constants/dimension.dart';
import '../../../utils/constants/string.dart';
import '../../global/container_card.dart';
import '../product_detail_widgets/icon_widget_row.dart';

class OrderCard extends StatelessWidget {
  OrderCard({
    super.key,
    this.orderStatus = 'Preparing',
    this.backgroundColor = AppColors.orangeBackgroundColor,
    this.labelColor = AppColors.orangeColor,
  });
  final String orderStatus;
  Color backgroundColor;
  Color labelColor;
  @override
  Widget build(BuildContext context) {
    bool isPickup;
    if (orderStatus == orderReceived ||
        orderStatus == orderReadyForPickup ||
        orderStatus == orderCompleted)
      isPickup = true;
    else {
      isPickup = false;
    }
    if (orderStatus == orderPreparing || orderStatus == orderReceived) {
      backgroundColor = AppColors.orangeBackgroundColor;
      labelColor = AppColors.orangeColor;
    } else if (orderStatus == orderDelivering ||
        orderStatus == orderReadyForPickup) {
      backgroundColor = AppColors.blueBackgroundColor;
      labelColor = Colors.blue;
    } else if (orderStatus == orderDelivered || orderStatus == orderCompleted) {
      backgroundColor = AppColors.greenBackgroundColor;
      labelColor = AppColors.greenColor;
    } else if (orderStatus == orderDeliveryFailed) {
      backgroundColor = AppColors.pinkBackgroundColor;
      labelColor = AppColors.pinkColor;
    }
    return ContainerCard(
        horizontalPadding: Dimension.height16,
        verticalPadding: Dimension.height16,
        child: Column(
          children: [
            //order status and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OrderStatusLabel(
                    backgroundColor: backgroundColor,
                    foregroundColor: labelColor,
                    text: orderStatus),
                Text(
                  '20/04/2020, 04:20',
                  style: TextStyle(
                      fontSize: Dimension.height12,
                      color: AppColors.greyTextColor),
                ),
              ],
            ),

            SizedBox(
              height: Dimension.height20,
            ),

            //store address
            IconWidgetRow(
              icon: Icons.store_rounded,
              crossAxisAlignment: CrossAxisAlignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '13 Han Thuyen, D.1, HCM city',
                    style: AppText.style.regular,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              color: AppColors.greyBoxColor,
            ),

            //to address
            IconWidgetRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              icon: isPickup
                  ? Icons.access_time_filled_sharp
                  : Icons.location_pin,
              iconColor:
                  isPickup ? AppColors.orangeColor : AppColors.greenColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '285 CMT8, D.10, HCM city',
                    style: AppText.style.regular,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: Dimension.height20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Dimension.height230,
                  child: Column(
                    children: [
                      Text(
                        'Capuccino (x1), Smoky hamburger (x1)',
                        style: AppText.style.regular,
                      ),
                    ],
                  ),
                ),
                Text(
                  '334.000 ₫',
                  style: AppText.style.boldBlack14,
                ),
              ],
            )
          ],
        ));
  }
}
