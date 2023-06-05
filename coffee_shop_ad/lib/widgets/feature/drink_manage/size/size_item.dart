import 'package:coffee_shop_admin/services/functions/money_transfer.dart';
import 'package:coffee_shop_admin/services/models/size.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';

class SizeItem extends StatelessWidget {
  final Size product;

  const SizeItem({super.key, required this.product});

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
                  .pushNamed("/size_detail_screen", arguments: product);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: Alignment.topCenter, children: [
                  Image.network(
                    product.image,
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
