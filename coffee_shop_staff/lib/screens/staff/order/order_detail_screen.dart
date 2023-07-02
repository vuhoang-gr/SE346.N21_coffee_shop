import 'package:coffee_shop_staff/services/blocs/order/order_bloc.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/constants/order_enum.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:coffee_shop_staff/widgets/features/order_screen/order_status_label.dart';
import 'package:coffee_shop_staff/widgets/features/order_screen/price_row.dart';
import 'package:coffee_shop_staff/widgets/global/buttons/rounded_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/features/order_screen/order_product_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/models/order.dart';
import '../../../utils/constants/dimension.dart';
import '../../../widgets/features/order_screen/icon_widget_row.dart';
import '../../../widgets/global/container_card.dart';
import '../../../widgets/global/custom_app_bar.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.order});
  final Order order;
  static const String routeName = 'order_detail_screen/';

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order order;
  late OrderStatus orderStatusTemp;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    orderStatusTemp = order.status;
  }

  @override
  Widget build(BuildContext context) {
    //Image pre-processing
    String imgUrl;
    if (order.status == OrderStatus.delivering) {
      imgUrl = 'assets/images/img_delivering.png';
    } else if (order.status == OrderStatus.delivered ||
        widget.order.status == OrderStatus.completed) {
      imgUrl = 'assets/images/img_delivered.png';
    } else if (order.status == OrderStatus.received) {
      imgUrl = 'assets/images/img_received.png';
    } else if (order.status == OrderStatus.prepared) {
      imgUrl = 'assets/images/img_ready_for_pickup.png';
    } else if (order.status == OrderStatus.deliverFailed ||
        order.status == OrderStatus.cancelled) {
      imgUrl = 'assets/images/img_delivery_failed.png';
    } else {
      imgUrl = 'assets/images/img_preparing.png';
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            CustomAppBar(
              leading: Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 150),
                child: Text(
                  order.id,
                  style: TextStyle(
                      fontSize: Dimension.height18,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: OrderStatusLabel(status: order.status),
            ),
            SizedBox(
              height: Dimension.height10,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimension.height12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        imgUrl,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                      ),
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
                        verticalPadding: Dimension.height16,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ID',
                                  style: AppText.style.regular,
                                  softWrap: true,
                                ),
                                Text(
                                  order.id,
                                  style: AppText.style.boldBlack14,
                                ),
                              ],
                            ),
                            const Divider(
                              color: AppColors.greyBoxColor,
                              thickness: 1.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order date',
                                  style: AppText.style.regular,
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy, hh:mm:ss')
                                      .format(order.orderDate),
                                  style: AppText.style.boldBlack14,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: Dimension.height16,
                      ),

                      //Delivery details
                      Text(
                        "Delivery details",
                        style: AppText.style.boldBlack16,
                      ),
                      SizedBox(
                        height: Dimension.height8,
                      ),

                      ContainerCard(
                        verticalPadding: Dimension.height16,
                        child: Column(
                          children: [
                            IconWidgetRow(
                              icon: order.isPickup
                                  ? Icons.access_time_filled
                                  : Icons.store_rounded,
                              iconColor: AppColors.orangeColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      widget.order.isPickup
                                          ? 'Pick up time'
                                          : 'Delivery to',
                                      style: AppText.style.regular),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  Text(
                                      order.isPickup
                                          ? DateFormat('dd/MM/yyyy, hh:mm:ss')
                                              .format(order.pickupTime!)
                                          : order.deliveryAddress!.address
                                              .formattedAddress,
                                      style: AppText.style.boldBlack14)
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.greyBoxColor,
                            ),
                            IconWidgetRow(
                              icon: Icons.person,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Receiver: ${order.user.name}',
                                      style: AppText.style.regular),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  Text(order.user.phoneNumber,
                                      style: AppText.style.boldBlack14)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: Dimension.height16,
                      ),

                      //Product info
                      Text(
                        "Products info",
                        style: AppText.style.boldBlack16,
                      ),
                      SizedBox(
                        height: Dimension.height8,
                      ),
                      ContainerCard(
                        child: Column(
                          children: [
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return OrderProductCard(
                                    product: order.productList[index],
                                  );
                                },
                                separatorBuilder: (_, __) => const Divider(
                                      color: AppColors.greyBoxColor,
                                      thickness: 1,
                                    ),
                                itemCount: order.productList.length),
                            SizedBox(
                              height: Dimension.height24,
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: Dimension.height16,
                      ),

                      //Payment info
                      Text(
                        "Payment info",
                        style: AppText.style.boldBlack16,
                      ),
                      SizedBox(
                        height: Dimension.height8,
                      ),
                      ContainerCard(
                        verticalPadding: Dimension.height16,
                        child: Column(
                          children: [
                            //price
                            PriceRow(
                              title: 'Price',
                              price: order.totalPrice +
                                  (order.discount ?? 0) -
                                  (order.deliveryFee ?? 0),
                            ),
                            SizedBox(
                              height: Dimension.height16,
                            ),
                            //shipping fee
                            PriceRow(
                              title: 'Delivery fee',
                              price: (order.deliveryFee ?? 0),
                            ),
                            SizedBox(
                              height: Dimension.height16,
                            ),
                            //promotion
                            PriceRow(
                              title: 'Discounted',
                              price: (order.discount ?? 0),
                            ),
                            SizedBox(
                              height: Dimension.height16,
                            ),
                            //total
                            PriceRow(
                              title: 'Price',
                              price: order.totalPrice,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimension.height6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimension.height12),
              child: ContainerCard(
                verticalPadding: Dimension.height12,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Change status: ',
                          style: AppText.style.regularGrey14
                              .copyWith(color: Colors.black),
                        ),
                        DropdownButtonHideUnderline(
                          child: Builder(builder: (context) {
                            List<OrderStatus> statusList = [];
                            if (order.isPickup) {
                              statusList = [
                                OrderStatus.received,
                                OrderStatus.prepared,
                                OrderStatus.completed,
                                OrderStatus.cancelled
                              ];
                            } else {
                              statusList = [
                                OrderStatus.preparing,
                                OrderStatus.delivering,
                                OrderStatus.delivered,
                                OrderStatus.deliverFailed,
                                OrderStatus.cancelled
                              ];
                            }
                            return DropdownButton2(
                              customButton: OrderStatusLabel(
                                hasBorder: true,
                                status: orderStatusTemp,
                                fontSize: 15,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                              ),
                              value: orderStatusTemp.name,
                              items: statusList.map((value) {
                                return DropdownMenuItem(
                                    value: value.name,
                                    child: OrderStatusLabel(
                                      status: value,
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  orderStatusTemp =
                                      (value as String).toOrderStatus();
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.blueColor,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 400,
                                width: 200,
                                padding: null,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                ),
                                elevation: 3,
                                offset: const Offset(-20, 315),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimension.height6,
                    ),
                    RoundedButton(
                      onPressed: () async {
                        setState(() {
                          order.status = orderStatusTemp;
                        });
                        // await OrderAPI().update(order);
                        if (context.mounted) {
                          context
                              .read<OrderBloc>()
                              .add(ChangeOrder(order: order));
                        }
                      },
                      label: 'CONFIRM',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
