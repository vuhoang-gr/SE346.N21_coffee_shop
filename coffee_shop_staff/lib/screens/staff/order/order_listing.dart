import 'package:coffee_shop_staff/services/models/order.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

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
    required this.onRefresh,
  });
  List<Order>? orderList;
  Future<void> Function() onRefresh;

  @override
  State<OrderListing> createState() => _OrderListingState();
}

class _OrderListingState extends State<OrderListing> {
  OrderStatus filter = OrderStatus.all;
  List<Order>? filterList;

  @override
  void initState() {
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

  Future<void> onRefresh() async {
    await widget.onRefresh();
    await Future.delayed(Duration(milliseconds: 5));
    setState(() {});
    onFilter();
  }

  @override
  Widget build(BuildContext context) {
    var isNotEmpty = widget.orderList != null && widget.orderList!.isNotEmpty;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
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
                    padding: EdgeInsets.symmetric(
                        vertical: Dimension.getHeightFromValue(9),
                        horizontal: Dimension.getWidthFromValue(11)),
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
                                OrderStatus.preparing,
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
                                fontSize: Dimension.getFontSize(13),
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimension.getHeightFromValue(9),
                                    horizontal:
                                        Dimension.getWidthFromValue(14)),
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
              ? Expanded(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimension.height12),
                      child: Column(
                        children: [
                          Flexible(
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
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
                          ),
                          SizedBox(
                            height: Dimension.height10,
                          ),
                        ],
                      )),
                )
              : Expanded(
                  child: NoOrderScreen(
                  onRefresh: widget.onRefresh,
                  onFilter: onFilter,
                )),
        ],
      ),
    );
  }
}

class NoOrderScreen extends StatelessWidget {
  NoOrderScreen({super.key, required this.onRefresh, required this.onFilter});
  final Future<void> Function() onRefresh;
  final void Function() onFilter;

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
              'Chưa có đơn hàng nào!',
              style: AppText.style.boldBlack16,
            ),
            SizedBox(
              height: Dimension.height8 / 2,
            ),
            Text(
              'Bạn nghĩ đây là lỗi?',
              style: AppText.style.regular,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimension.height16, vertical: Dimension.height16),
              child: ElevatedButton(
                  style: roundedButton,
                  onPressed: () async {
                    await onRefresh();
                    await Future.delayed(Duration(milliseconds: 5));
                    onFilter();
                    // context.read<OrderBloc>().add(FetchOrder());
                  },
                  child: SizedBox(
                    height: Dimension.height40,
                    width: double.maxFinite,
                    child: Center(
                      child: Text(
                        'THỬ LẠI!',
                        style: TextStyle(
                            fontSize: Dimension.getFontSize(15),
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
