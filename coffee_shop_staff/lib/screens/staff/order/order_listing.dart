import 'package:coffee_shop_staff/services/models/order.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/button.dart';
import '../../../widgets/features/order_screen/order_card.dart';

// ignore: must_be_immutable
class OrderListing extends StatelessWidget {
  OrderListing({
    super.key,
    this.orderList,
  });
  List<Order>? orderList;

  @override
  Widget build(BuildContext context) {
    return orderList != null && orderList!.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimension.height12),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: Dimension.height12,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return OrderCard(
                        order: orderList![index],
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(
                      height: Dimension.height12,
                    ),
                    itemCount: orderList!.length,
                  ),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                ],
              ),
            ))
        : ColoredBox(
            color: Colors.white,
            child: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(
                    height: Dimension.height150 / 2,
                  ),
                  Image.asset('assets/images/img_no_order.png'),
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
                        horizontal: Dimension.height16,
                        vertical: Dimension.height16),
                    child: ElevatedButton(
                        style: roundedButton,
                        onPressed: () {},
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
