import 'package:coffee_shop_app/services/models/store.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/button.dart';
import '../../global/container_card.dart';
import '../product_detail_widgets/icon_widget_row.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoreInfoDialog extends StatelessWidget {
  const StoreInfoDialog({super.key, required this.store});
  final Store store;
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
                imageUrl: store.images[0],
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
                  Text(store.sb, style: AppText.style.boldBlack18),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                  Text(
                    'Thông tin liên hệ cửa hàng',
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
                            'Số điện thoại',
                            style: AppText.style.regular,
                          ),
                          Text(
                            store.phone,
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
                      child: Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Địa chỉ',
                              style: AppText.style.regular,
                            ),
                            Text(
                              store.address.formattedAddress,
                              style: AppText.style.boldBlack14,
                            ),
                          ],
                        ),
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
                            'Đóng',
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
