import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';
import '../product_detail_widgets/round_image.dart';

class OrderManageProductItem extends StatelessWidget {
  const OrderManageProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimension.height8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RoundImage(
                imgUrl:
                    'https://product.hstatic.net/1000075078/product/cold-brew-sua-tuoi_379576_7fd130b7d162497a950503207876ef64.jpg'),
            SizedBox(
              width: Dimension.height8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capuccino',
                    style: AppText.style.boldBlack14,
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Text('Size: Small', style: AppText.style.regularGrey12),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Text('69.000 ₫ x 1', style: AppText.style.regularGrey12),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimension.height8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.greyTextField)),
                    child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lectus rhoncus lorem risus sollicitudin.',
                        style: AppText.style.regularGrey12),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
