import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:flutter/cupertino.dart';

import '../../services/functions/money_transfer.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';

class ProductItem extends StatelessWidget {
  final Drink product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            color: CupertinoColors.white),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed("/product_detail_screen", arguments: product);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: Alignment.topCenter, children: [
                  Image.network(
                    product.images[0],
                    height: Dimension.height68,
                    width: Dimension.height68,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: Dimension.height8,
                  )
                ]),
                SizedBox(width: Dimension.width16),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppText.style.regular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimension.height4),
                    Text(
                      "${MoneyTransfer.transferFromDouble(product.price)} đ",
                      style: AppText.style.boldBlack14,
                    ),
                  ],
                ))
              ],
            )));
  }
}
