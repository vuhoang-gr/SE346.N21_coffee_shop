import 'package:coffee_shop_staff/services/blocs/order/order_bloc.dart';
import 'package:coffee_shop_staff/services/models/order.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/constants/order_enum.dart';
import '../../../utils/styles/button.dart';
import '../../../widgets/features/order_screen/order_card.dart';
import '../../../widgets/features/order_screen/order_status_label.dart';

// ignore: must_be_immutable
class OrderListing extends StatefulWidget {
  OrderListing({
    super.key,
    this.orderList,
  });
  List<Order>? orderList;

  @override
  State<OrderListing> createState() => _OrderListingState();
}

class _OrderListingState extends State<OrderListing> {
  OrderStatus filter = OrderStatus.all;
  List<Order>? filterList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterList = widget.orderList;
  }

  void onFilter() {
    List<Order>? newList;
    if (filter == OrderStatus.all) {
      newList = widget.orderList;
    } else {
      newList = widget.orderList!
          .where((element) => element.status == filter)
          .toList();
    }
    setState(() {
      filterList = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isNotEmpty = widget.orderList != null && widget.orderList!.isNotEmpty;
    return Column(
      children: [
        isNotEmpty
            ? SizedBox(
                height: Dimension.height12,
              )
            : SizedBox.shrink(),
        isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimension.height12),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chọn trạng thái: ',
                        style: AppText.style.regularGrey14
                            .copyWith(color: Colors.black),
                      ),
                      DropdownButtonHideUnderline(
                        child: Builder(builder: (context) {
                          List<OrderStatus> statusList = [];
                          if (widget.orderList![0].isPickup) {
                            statusList = [
                              OrderStatus.all,
                              OrderStatus.received,
                              OrderStatus.prepared,
                              OrderStatus.completed,
                              OrderStatus.cancelled,
                            ];
                          } else {
                            statusList = [
                              OrderStatus.all,
                              OrderStatus.preparing,
                              OrderStatus.delivering,
                              OrderStatus.delivered,
                              OrderStatus.deliverFailed,
                              OrderStatus.cancelled,
                            ];
                          }
                          return DropdownButton2(
                            customButton: OrderStatusLabel(
                              hasBorder: true,
                              status: filter,
                              fontSize: 15,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                            ),
                            value: filter.name,
                            items: statusList.map((value) {
                              return DropdownMenuItem(
                                  value: value.name,
                                  child: OrderStatusLabel(
                                    status: value,
                                  ));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                filter = value!.toOrderStatus();
                              });
                              onFilter();
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
                ),
              )
            : SizedBox.shrink(),
        SizedBox(
          height: isNotEmpty ? Dimension.height12 : 0,
        ),
        isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimension.height12),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return OrderCard(
                            order: filterList![index],
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(
                          height: Dimension.height12,
                        ),
                        itemCount: filterList!.length,
                      ),
                      SizedBox(
                        height: Dimension.height16,
                      ),
                    ],
                  ),
                ))
            : Expanded(child: NoOrderScreen()),
      ],
    );
  }
}

class NoOrderScreen extends StatelessWidget {
  const NoOrderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Dimension.height150 / 2,
            ),
            Image.asset(
              'assets/images/img_no_order.png',
              fit: BoxFit.cover,
              width: Dimension.width296 / 1.5,
            ),
            SizedBox(
              height: Dimension.height24,
            ),
            Text(
              'The store has no orders yet!',
              style: AppText.style.boldBlack16,
            ),
            SizedBox(
              height: Dimension.height8 / 2,
            ),
            Text(
              'You think this is a mistake?',
              style: AppText.style.regular,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimension.height16, vertical: Dimension.height16),
              child: ElevatedButton(
                  style: roundedButton,
                  onPressed: () {
                    context.read<OrderBloc>().add(LoadOrder());
                  },
                  child: SizedBox(
                    height: Dimension.height40,
                    width: double.maxFinite,
                    child: Center(
                      child: Text(
                        'Try again!',
                        style: TextStyle(
                            fontSize: Dimension.height16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
