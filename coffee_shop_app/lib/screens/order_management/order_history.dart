import 'package:coffee_shop_app/screens/order_management/pickup_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/order/order_delivery_cubit.dart';
import '../../services/blocs/order/order_list_state.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/global/custom_app_bar.dart';
import 'delivery_management.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        BlocProvider.of<OrderDeliveryCubit>(context).needHistory(false);

        //do something herre
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: ColoredBox(
            color: AppColors.backgroundColor,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  ColoredBox(
                    color: Colors.white,
                    child: SizedBox(
                      height: Dimension.height56,
                      child: CustomAppBar(
                        leading: Text(
                          'Lịch sử mua hàng',
                          style: AppText.style.boldBlack18,
                        ),
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
                              bottom:
                                  BorderSide(color: Colors.blue, width: 1.5))),
                      labelColor: Colors.blue,
                      labelStyle: AppText.style.boldBlack14,
                      unselectedLabelColor: AppColors.greyTextColor,
                      unselectedLabelStyle: AppText.style.regular,
                      tabs: const [
                        Tab(
                          text: 'Store pickup',
                        ),
                        Tab(
                          text: 'Delivery',
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<OrderDeliveryCubit, OrderListState>(
                      builder: (context, state) {
                    if (!state.isLoaded && state is OrderHistoryState) {
                      // BlocProvider.of<OrderDeliveryCubit>(context).loadOrder();
                    }
                    return Expanded(
                        child: TabBarView(
                      children: [
                        //store pickup
                        PickupManagement(),

                        //delivery
                        DeliveryManagement(),
                      ],
                    ));
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
