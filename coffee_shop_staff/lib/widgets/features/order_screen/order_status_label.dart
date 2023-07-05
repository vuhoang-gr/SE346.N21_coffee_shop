import 'package:coffee_shop_staff/utils/constants/order_enum.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';

//VHDONE
// ignore: must_be_immutable
class OrderStatusLabel extends StatelessWidget {
  OrderStatusLabel({
    super.key,
    required this.status,
    this.padding,
    this.fontSize = 14,
    this.hasBorder = false,
  }) {
    padding ??= EdgeInsets.symmetric(
        vertical: Dimension.height4, horizontal: Dimension.height12);
  }

  final OrderStatus status;
  EdgeInsets? padding;
  double? fontSize;
  final bool? hasBorder;
  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? foregroundColor;

    if (status == OrderStatus.preparing || status == OrderStatus.received) {
      backgroundColor = AppColors.orangeBackgroundColor;
      foregroundColor = AppColors.orangeColor;
    } else if (status == OrderStatus.delivering ||
        status == OrderStatus.prepared) {
      backgroundColor = AppColors.blueBackgroundColor;
      foregroundColor = Colors.blue;
    } else if (status == OrderStatus.delivered ||
        status == OrderStatus.completed) {
      backgroundColor = AppColors.greenBackgroundColor;
      foregroundColor = AppColors.greenColor;
    } else if (status == OrderStatus.deliverFailed ||
        status == OrderStatus.cancelled) {
      backgroundColor = AppColors.pinkBackgroundColor;
      foregroundColor = AppColors.pinkColor;
    } else {
      backgroundColor = AppColors.backgroundColor;
      foregroundColor = AppColors.blackColor;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
        border: hasBorder!
            ? Border.all(
                width: 1,
                color: foregroundColor,
              )
            : null,
      ),
      child: Text(
        status.name,
        style: TextStyle(
            fontSize: Dimension.getFontSize(fontSize!),
            fontWeight: FontWeight.w500,
            color: foregroundColor),
      ),
    );
  }
}
