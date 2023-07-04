import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_event.dart';
import 'package:coffee_shop_admin/services/functions/money_transfer.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/constants/placeholder_enum.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/global/aysncImage/async_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrinkItem extends StatelessWidget {
  final Drink product;

  const DrinkItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5), color: CupertinoColors.white),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/drink_detail_screen", arguments: product).then((value) {
                BlocProvider.of<DrinkListBloc>(context).add(FetchData());
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: Alignment.topCenter, children: [
                  AsyncImage(
                    src: product.images[0],
                    height: Dimension.height68,
                    width: Dimension.height68,
                    fit: BoxFit.cover,
                    type: PlaceholderType.food,
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
