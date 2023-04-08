import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants/dimension.dart';
import '../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../widgets/feature/store/store_detail_card.dart';
import '../widgets/global/container_card.dart';

class StoreDetail extends StatelessWidget {
  const StoreDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const StoreDetailCard(),
                SizedBox(
                  height: Dimension.height12,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: Dimension.height16, right: Dimension.height16),
                  child: Column(
                    children: [
                      ContainerCard(
                          verticalPadding: Dimension.height16,
                          child: SizedBox(
                            width: double.maxFinite,
                            height: Dimension.height150,
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: Dimension.width108,
                                          height: Dimension.height72,
                                          child: Image.asset(
                                            "assets\\images\\pickup_icon.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          height: Dimension.height8,
                                        ),
                                        Text(
                                          "Store pickup",
                                          style: AppText.style.mediumBlack16,
                                        ),
                                        Text(
                                          "Best quality",
                                          style: AppText.style.regularGrey14,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Dimension.width16,
                                ),
                                Container(
                                  height: Dimension.height48,
                                  width: Dimension.width1,
                                  color: AppColors.greyBoxColor,
                                ),
                                SizedBox(
                                  width: Dimension.width16,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: Dimension.width108,
                                          height: Dimension.height72,
                                          child: Image.asset(
                                            "assets\\images\\delivery_icon.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          height: Dimension.height8,
                                        ),
                                        Text(
                                          "Delivery",
                                          style: AppText.style.mediumBlack16,
                                        ),
                                        Text(
                                          "Always on time",
                                          style: AppText.style.regularGrey14,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: Dimension.height12,
                      ),
                      ContainerCard(
                        horizontalPadding: Dimension.height16,
                        verticalPadding: Dimension.height24,
                        child: Column(
                          children: [
                            IconWidgetRow(
                              icon: CupertinoIcons.phone_fill,
                              iconColor: AppColors.greenColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone number',
                                    style: AppText.style.regular,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  Text(
                                    '0909090909',
                                    style: AppText.style.boldBlack14,
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.greyBoxColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconWidgetRow(
                                  icon: Icons.location_pin,
                                  iconColor: Colors.blue,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address',
                                        style: AppText.style.regular,
                                      ),
                                      SizedBox(
                                        height: Dimension.height4,
                                      ),
                                      Text(
                                        '13 Han Thuyen, D.1, HCM city',
                                        style: AppText.style.boldBlack14,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimension.height16,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
