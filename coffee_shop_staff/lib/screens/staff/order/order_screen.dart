import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/apis/order_api.dart';
import '../../../services/apis/store_api.dart';
import '../../../services/blocs/order/order_bloc.dart';
import '../../../services/models/order.dart';
import 'order_listing.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../../../widgets/global/custom_app_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> deliList = [];
  List<Order> pickupList = [];

  Future<void> onRefresh() async {
    var orderListRaw = await OrderAPI().getAll(StoreAPI.currentStore!.id);
    var odList = orderListRaw?.map((e) => e as Order).toList();
    var pList = odList!
        .where(
          (element) => element.deliveryAddress == null,
        )
        .toList();
    var dList = odList
        .where(
          (element) => element.deliveryAddress != null,
        )
        .toList();
    setState(() {
      deliList = dList;
    });
    setState(() {
      pickupList = pList;
    });
    if (context.mounted) {
      context
          .read<OrderBloc>()
          .add(LoadOrder(deli: deliList, pickup: pickupList));
    }
    setState(() {});
    await Future.delayed(Duration(milliseconds: 5));
  }

  @override
  void initState() {
    super.initState();

    var orderState = context.read<OrderBloc>().state;
    if (orderState is OrderLoaded) {
      deliList = orderState.delivery;
      pickupList = orderState.pickup;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              SizedBox(
                height: Dimension.height56,
                child: CustomAppBar(
                  leading: Text(
                    'Đơn hàng',
                    style: TextStyle(
                        fontSize: Dimension.font18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: Dimension.height45,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: AppColors.greyBoxColor, width: 1.5))),
                child: TabBar(
                  indicator: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 1.5))),
                  labelColor: Colors.blue,
                  labelStyle: AppText.style.boldBlack14,
                  unselectedLabelColor: AppColors.greyTextColor,
                  unselectedLabelStyle: AppText.style.regular,
                  tabs: const [
                    Tab(
                      text: 'Đến lấy',
                    ),
                    Tab(
                      text: 'Vận chuyển',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    //store pickup
                    //map order have pickup type
                    OrderListing(
                      orderList: pickupList,
                      onRefresh: onRefresh,
                    ),

                    //delivery
                    //map order have delivery type
                    OrderListing(
                      orderList: deliList,
                      onRefresh: onRefresh,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
