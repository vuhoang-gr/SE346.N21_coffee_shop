import 'package:coffee_shop_app/services/models/order_food.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../../services/functions/money_transfer.dart';
import '../../../utils/constants/dimension.dart';
import '../product_detail_widgets/round_image.dart';

class OrderManageProductItem extends StatelessWidget {
  const OrderManageProductItem({super.key, required this.orderItem});
  final OrderFood orderItem;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimension.height8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundImage(imgUrl: orderItem.image),
            SizedBox(
              width: Dimension.height8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderItem.name,
                    style: AppText.style.boldBlack14,
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Text('Size: ${orderItem.size}',
                      style: AppText.style.regularGrey12),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  orderItem.topping == null || orderItem.topping == ''
                      ? SizedBox.shrink()
                      : Text('Topping: ${orderItem.topping}',
                          style: AppText.style.regularGrey12),
                  orderItem.topping == null || orderItem.topping == ''
                      ? SizedBox.shrink()
                      : SizedBox(
                          height: Dimension.height4,
                        ),
                  Text(
                      '${MoneyTransfer.transferFromDouble(orderItem.unitPrice)} ₫ x ${orderItem.quantity}',
                      style: AppText.style.regularGrey12),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  orderItem.note == null || orderItem.note!.isEmpty
                      ? SizedBox.shrink()
                      : Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(Dimension.height8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: AppColors.greyTextField)),
                          child: Text(orderItem.note!,
                              style: AppText.style.regularGrey12),
                        ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
