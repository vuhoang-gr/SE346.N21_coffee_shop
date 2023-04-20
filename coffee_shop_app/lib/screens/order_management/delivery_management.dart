import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/dimension.dart';
import '../../utils/styles/button.dart';
import '../../widgets/feature/order_widgets/order_card.dart';

class DeliveryManagement extends StatelessWidget {
  const DeliveryManagement({super.key, this.hasOrder = true});
  final bool hasOrder;

  @override
  Widget build(BuildContext context) {
    return hasOrder
        ? Padding(
            padding: EdgeInsets.only(
                left: Dimension.height16, right: Dimension.height16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Dimension.height16,
                  ),
                  ListView.separated(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return OrderCard(
                          orderStatus: 'Delivered',
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(
                            height: Dimension.height12,
                          ),
                      itemCount: 4),
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
                    'You have no order',
                    style: AppText.style.boldBlack16,
                  ),
                  SizedBox(
                    height: Dimension.height8 / 2,
                  ),
                  Text(
                    'How about trying our new drinks?',
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
                              'Order now!',
                              style: AppText.style.regularBlack16,
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
