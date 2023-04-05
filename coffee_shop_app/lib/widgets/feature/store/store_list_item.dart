
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../utils/constants/dimension.dart';
import '../../global/container_card.dart';
import '../product_detail_widgets/icon_widget_row.dart';

class StoreListItem extends StatelessWidget {
  const StoreListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerCard(
        verticalPadding: Dimension.height8,
        horizontalPadding: Dimension.height16,
        child: IconWidgetRow(
          icon: Icons.store,
          iconColor: const Color.fromRGBO(196, 196, 207, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SB Van Hanh Mall',
                style: TextStyle(
                    fontSize: Dimension.font14,
                    fontWeight: FontWeight.w500,
                    height: 1.5),
              ),
              Text(
                '11 Su Van Hanh, D.10, HCM city',
                style: TextStyle(
                    color: AppColors.greyTextColor,
                    fontSize: Dimension.height12,
                    fontWeight: FontWeight.w400,
                    height: 1.5),
              ),
            ],
          ),
        ));
  }
}
