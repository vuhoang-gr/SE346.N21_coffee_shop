import 'package:coffee_shop_app/services/functions/datetime_to_pickup.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/widgets/feature/order_widgets/order_status_label.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/functions/money_transfer.dart';
import '../../../services/models/order.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/constants/string.dart';
import '../../global/container_card.dart';
import '../product_detail_widgets/icon_widget_row.dart';

class OrderCard extends StatelessWidget {
  OrderCard({
    super.key,
    required this.order,
    this.backgroundColor = AppColors.orangeBackgroundColor,
    this.labelColor = AppColors.orangeColor,
  });
  final Order order;
  Color backgroundColor;
  Color labelColor;
  @override
  Widget build(BuildContext context) {
    bool isPickup;
    if (order.pickupTime != null) {
      isPickup = true;
    } else {
      isPickup = false;
    }
    if (order.status == orderProcessing) {
      backgroundColor = AppColors.orangeBackgroundColor;
      labelColor = AppColors.orangeColor;
    } else if (order.status == orderDelivering ||
        order.status == orderReadyForPickup) {
      backgroundColor = AppColors.blueBackgroundColor;
      labelColor = Colors.blue;
    } else if (order.status == orderDelivered ||
        order.status == orderCompleted) {
      backgroundColor = AppColors.greenBackgroundColor;
      labelColor = AppColors.greenColor;
    } else if (order.status == orderCancelled || order.status == orderFailed) {
      backgroundColor = AppColors.pinkBackgroundColor;
      labelColor = AppColors.pinkColor;
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/order_detail_screen", arguments: order);
      },
      child: ContainerCard(
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
                      text: order.status),
                  Builder(builder: (context) {
                    var day = DateFormat('dd/MM/yyyy')
                        .format(order.dateOrder)
                        .toString();
                    return Text('$day, ${datetimeToHour(order.dateOrder)}',
                        style: AppText.style.regularGrey12);
                  }),
                ],
              ),

              SizedBox(
                height: Dimension.height20,
              ),

              //store address
              IconWidgetRow(
                icon: Icons.store_rounded,
                crossAxisAlignment: CrossAxisAlignment.center,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.store!.address.formattedAddress,
                        style: AppText.style.regular,
                      ),
                    ],
                  ),
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
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPickup
                            ? datetimeToPickup(order.pickupTime!)
                            : order.address!.address.formattedAddress,
                        style: AppText.style.regular,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: Dimension.height20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          Map<String, int> map = {};
                          for (var prd in order.products) {
                            map.containsKey(prd.name)
                                ? map.update(
                                    prd.name, (value) => value + prd.quantity)
                                : map[prd.name] = prd.quantity;
                          }

                          List<String> names = [];
                          map.forEach(
                            (key, value) => names.add('$key (x$value)'),
                          );
                          return Text(
                            names.join(', '),
                            style: AppText.style.regular,
                          );
                        }),
                      ],
                    ),
                  ),
                  Text(
                    '${MoneyTransfer.transferFromDouble(order.total!)} ₫',
                    style: AppText.style.boldBlack14,
                  ),
                ],
              )
            ],
          )),
    );
  }
}
