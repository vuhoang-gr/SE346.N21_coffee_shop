import 'package:coffee_shop_staff/screens/staff/order/order_detail_screen.dart';
import 'package:coffee_shop_staff/services/models/order.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/constants/order_enum.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:coffee_shop_staff/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/dimension.dart';
import 'icon_widget_row.dart';
import 'order_status_label.dart';
import '../../global/container_card.dart';
import 'price_row.dart';

//VHDONE
// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  OrderCard({
    super.key,
    required this.order,
  }) {
    orderStatus = order.status;
  }

  Order order;

  late OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () {
        Navigator.of(context)
            .pushNamed(OrderDetailScreen.routeName, arguments: order);
      },
      child: ContainerCard(
          horizontalPadding: Dimension.height16,
          verticalPadding: Dimension.height16,
          child: Column(
            children: [
              //Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OrderStatusLabel(
                    status: orderStatus,
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy hh:mm:ss').format(order.orderDate),
                    style: TextStyle(
                        fontSize: Dimension.font12,
                        color: AppColors.greyTextColor),
                  ),
                ],
              ),

              SizedBox(
                height: Dimension.height20,
              ),

              //Order ID
              IconWidgetRow(
                icon: Icons.tag,
                crossAxisAlignment: CrossAxisAlignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style: AppText.style.regular,
                    ),
                  ],
                ),
              ),

              const Divider(
                thickness: 1,
                color: AppColors.greyBoxColor,
              ),

              //Delivery Address
              IconWidgetRow(
                crossAxisAlignment: CrossAxisAlignment.center,
                icon: Icons.location_pin,
                iconColor: AppColors.greenColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.isPickup
                          ? 'Đến lấy'
                          : order.deliveryAddress!.address.formattedAddress,
                      style: AppText.style.regular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: Dimension.height20,
              ),

              //Order summary
              Builder(builder: (context) {
                String productSummary = order.productList
                    .map((item) => '${item.name} (${item.amount})')
                    .join(", ");
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    productSummary,
                    style: AppText.style.regular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),

              const Divider(
                thickness: 1,
                color: AppColors.greyBoxColor,
              ),

              //Price
              !order.isPickup
                  ? PriceRow(
                      title: 'Tổng hóa đơn',
                      price: order.deliveryFee ?? 0,
                    )
                  : SizedBox.shrink(),
              PriceRow(title: 'Giảm giá', price: order.discount ?? 0),
              PriceRow(title: 'Tổng tiền', price: order.totalPrice),
            ],
          )),
    );
  }
}
