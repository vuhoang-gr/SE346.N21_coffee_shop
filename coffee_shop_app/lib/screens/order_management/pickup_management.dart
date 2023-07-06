import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/order/order_delivery_cubit.dart';
import '../../services/blocs/order/order_list_state.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/button.dart';
import '../../widgets/feature/order_widgets/order_card.dart';
import '../../widgets/feature/order_widgets/order_skeleton.dart';
import '../main_page.dart';

class PickupManagement extends StatelessWidget {
  const PickupManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDeliveryCubit, OrderListState>(
        builder: (context, state) {
      if (!state.isLoaded) {
        return ListView.builder(
          itemBuilder: (context, index) => OrderSkeleton(),
          itemCount: 5,
        );
      } else {
        return state.listPickupOrders.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    left: Dimension.height16, right: Dimension.height16),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await BlocProvider.of<OrderDeliveryCubit>(context)
                        .loadFromFirebase();
                  },
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimension.height16),
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return OrderCard(
                              order: state.listPickupOrders[index],
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(
                                height: Dimension.height12,
                              ),
                          itemCount: state.listPickupOrders.length),
                    );
                  }),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await BlocProvider.of<OrderDeliveryCubit>(context)
                      .loadFromFirebase();
                },
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: state is OrderNormalState
                          ? Column(
                              children: [
                                SizedBox(
                                  height: Dimension.height150 / 2,
                                ),
                                SizedBox(
                                    height: 150,
                                    child: Image.asset(
                                        'assets/images/img_no_order.png')),
                                SizedBox(
                                  height: Dimension.height24,
                                ),
                                Text(
                                  'Bạn chưa có đơn hàng ?',
                                  style: AppText.style.boldBlack16,
                                ),
                                SizedBox(
                                  height: Dimension.height8 / 2,
                                ),
                                Text(
                                  'Hãy thử thức uống mới nhất của chúng tôi',
                                  style: AppText.style.regular,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimension.height16,
                                      vertical: Dimension.height16),
                                  child: ElevatedButton(
                                      style: roundedButton,
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MainPage(
                                                      selectedPage: 1,
                                                    )));
                                      },
                                      child: SizedBox(
                                        height: Dimension.height40,
                                        width: double.maxFinite,
                                        child: Center(
                                          child: Text(
                                            'Đặt hàng ngay!',
                                            style: AppText.style.regularWhite16,
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: Dimension.height150 / 2,
                                  width: double.maxFinite,
                                ),
                                Image.asset(
                                  'assets/images/img_no_order.png',
                                  height: 150,
                                ),
                                SizedBox(
                                  height: Dimension.height24,
                                ),
                                Text(
                                  'Bạn chưa có đơn hàng nào !',
                                  style: AppText.style.boldBlack16,
                                ),
                              ],
                            ),
                    ),
                  );
                }),
              );
      }
    });
  }
}
