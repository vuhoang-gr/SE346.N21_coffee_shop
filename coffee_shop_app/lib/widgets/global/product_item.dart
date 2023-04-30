import 'package:flutter/cupertino.dart';

import '../../services/functions/money_transfer.dart';
import '../../services/functions/shared_preferences_helper.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String productName;
  final double productPrice;
  final String imageProduct;
  final bool isAvailable;
  final DateTime dateRegister;

  const ProductItem(
      {super.key,
      required this.id,
      required this.productName,
      required this.productPrice,
      required this.imageProduct,
      required this.dateRegister,
      this.isAvailable = true});

  bool get isNew =>
      DateTime.now().difference(dateRegister) < const Duration(days: 7);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            color: CupertinoColors.white),
        child: isAvailable
            ? GestureDetector(
                onTap: () {
                  SharedPreferencesHelper.addProductToSharedPreferences(id)
                      .then((_) => Navigator.of(context).pushNamed(
                          "/product_detail_screen",
                          arguments: {"id": id}));
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
                                Image.network(
                                  imageProduct,
                                  height: Dimension.height68,
                                  width: Dimension.height68,
                                  fit: BoxFit.cover,
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
                                Image.network(
                                  imageProduct,
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
                          productName,
                          style: AppText.style.regular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimension.height4),
                        Text(
                          "${MoneyTransfer.transferFromDouble(productPrice)} đ",
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
                          ? [
                              SizedBox(
                                height: Dimension.height68 + Dimension.height8,
                              ),
                              Image.network(
                                imageProduct,
                                height: Dimension.height68,
                                width: Dimension.height68,
                                fit: BoxFit.cover,
                                opacity: const AlwaysStoppedAnimation(.3),
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
                              Image.network(
                                imageProduct,
                                height: Dimension.height68,
                                width: Dimension.height68,
                                fit: BoxFit.cover,
                                opacity: const AlwaysStoppedAnimation(.3),
                              ),
                            ]),
                  SizedBox(width: Dimension.width16),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: AppText.style.regularBlack14Blur,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Dimension.height4),
                      Text(
                        "${MoneyTransfer.transferFromDouble(productPrice)} đ",
                        style: AppText.style.boldBlack14Blur,
                      ),
                      SizedBox(height: Dimension.height4),
                      Text(
                        "Not available at this store",
                        style: AppText.style.regularBlack10,
                      )
                    ],
                  ))
                ],
              )));
  }
}
