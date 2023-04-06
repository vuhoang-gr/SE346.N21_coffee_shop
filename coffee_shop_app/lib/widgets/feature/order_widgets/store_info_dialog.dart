import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/button.dart';
import '../../global/container_card.dart';
import '../product_detail_widgets/icon_widget_row.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoreInfoDialog extends StatelessWidget {
  const StoreInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      child: ContainerCard(
        horizontalPadding: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 3,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: double.maxFinite,
                imageUrl:
                    'https://images.edrawmind.com/article/swot-analysis-of-coffee-shop/1200_800.jpg',
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(),
              ),
            ),
            SizedBox(
              height: Dimension.height16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimension.height16),
              child: Column(
                children: [
                  Text(
                    'SB Han Thuyen',
                    style: TextStyle(
                        fontSize: Dimension.height18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                  Text(
                    'Store contact informations',
                    style: AppText.style.regular,
                  ),
                  SizedBox(
                    height: Dimension.height24,
                  ),
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
                          Text(
                            '0909090909',
                            style: AppText.style.boldBlack14,
                          ),
                        ],
                      )),
                  const Divider(
                    color: AppColors.greyBoxColor,
                    thickness: 1,
                  ),
                  IconWidgetRow(
                      icon: Icons.location_pin,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address',
                            style: AppText.style.regular,
                          ),
                          Text(
                            '13 Han Thuyen, D.1, HCM city',
                            style: AppText.style.boldBlack14,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: Dimension.height24,
                  ),
                  OutlinedButton(
                      style: outlinedButton,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                          width: double.maxFinite,
                          height: Dimension.height40,
                          child: Center(
                              child: Text(
                            'Close',
                            style: AppText.style.boldBlack16
                                .copyWith(fontWeight: FontWeight.normal),
                          )))),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
