import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/product_detail/product_detail_bloc.dart';
import 'package:coffee_shop_app/services/blocs/product_detail/product_detail_event.dart';
import 'package:coffee_shop_app/services/blocs/recent_see_products/recent_see_products_bloc.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:coffee_shop_app/widgets/global/aysncImage/async_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/recent_see_products/recent_see_products_event.dart';
import '../../services/functions/money_transfer.dart';
import '../../services/models/store.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/constants/placeholder_enum.dart';
import '../../utils/styles/app_texts.dart';

class ProductItem extends StatelessWidget {
  final Food product;

  const ProductItem({super.key, required this.product});

  bool get isNew =>
      DateTime.now().difference(product.dateRegister) < const Duration(days: 7);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            color: CupertinoColors.white),
        child: product.isAvailable
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context
                      .read<RecentSeeProductsBloc>()
                      .add(ListRecentSeeProductChanged(product: product));
                  Store? store =
                      context.read<CartButtonBloc>().state.selectedStore;
                  context.read<ProductDetailBloc>().add(InitProduct(
                      selectedProduct: product,
                      bannedSize: store?.stateFood[product.id] ?? [],
                      bannedTopping: store?.stateTopping ?? []));
                  Navigator.of(context).pushNamed("/product_detail_screen");
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                        alignment: Alignment.topCenter,
                        children: isNew
                            ? [
                                SizedBox(
                                  height:
                                      Dimension.height68 + Dimension.height8,
                                ),
                                AsyncImage(
                                  src: product.images[0],
                                  height: Dimension.height68,
                                  width: Dimension.height68,
                                  fit: BoxFit.cover,
                                  type: PlaceholderType.food,
                                ),
                                Positioned(
                                    top: Dimension.height68 - Dimension.height8,
                                    child: Container(
                                      height: Dimension.height16,
                                      width: Dimension.width32,
                                      decoration: const BoxDecoration(
                                          color: AppColors.redColor,
                                          border: Border.symmetric(
                                            vertical: BorderSide(
                                                color: CupertinoColors.white,
                                                width: 1),
                                            horizontal: BorderSide(
                                              color: CupertinoColors.white,
                                              width: 1,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                    )),
                                Positioned(
                                    top: Dimension.height68 -
                                        Dimension.height8 -
                                        (Dimension.height1 / 2),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimension.width4),
                                      child: Text("NEW",
                                          textAlign: TextAlign.center,
                                          style: AppText.style.boldWhite10),
                                    ))
                              ]
                            : [
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
                ))
            : (Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                      alignment: Alignment.topCenter,
                      children: isNew
                          ? <Widget>[
                              SizedBox(
                                height: Dimension.height68 + Dimension.height8,
                              ),
                              Opacity(
                                opacity: 0.3,
                                child: AsyncImage(
                                  src: product.images[0],
                                  height: Dimension.height68,
                                  width: Dimension.height68,
                                  fit: BoxFit.cover,
                                  type: PlaceholderType.food,
                                ),
                              ),
                              Positioned(
                                  top: Dimension.height68 - Dimension.height8,
                                  child: Container(
                                    height: Dimension.height16,
                                    width: Dimension.width32,
                                    decoration: const BoxDecoration(
                                        color: AppColors.redBlurColor,
                                        border: Border.symmetric(
                                          vertical: BorderSide(
                                              color: CupertinoColors.white,
                                              width: 1),
                                          horizontal: BorderSide(
                                            color: CupertinoColors.white,
                                            width: 1,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  )),
                              Positioned(
                                  top: Dimension.height68 -
                                      Dimension.height8 -
                                      (Dimension.height1 / 2),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimension.width4),
                                    child: Text("NEW",
                                        textAlign: TextAlign.center,
                                        style: AppText.style.boldWhite10),
                                  ))
                            ]
                          : [
                              Opacity(
                                opacity: 0.3,
                                child: AsyncImage(
                                  src: product.images[0],
                                  height: Dimension.height68,
                                  width: Dimension.height68,
                                  fit: BoxFit.cover,
                                  type: PlaceholderType.food,
                                ),
                              ),
                            ]),
                  SizedBox(width: Dimension.width16),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppText.style.regularBlack14Blur,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Dimension.height4),
                      Text(
                        "${MoneyTransfer.transferFromDouble(product.price)} đ",
                        style: AppText.style.boldBlack14Blur,
                      ),
                      SizedBox(height: Dimension.height4),
                      Text(
                        "Cửa hàng không có sẵn",
                        style: AppText.style.regularBlack10,
                      )
                    ],
                  ))
                ],
              )));
  }
}
