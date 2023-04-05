import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/button.dart';
import '../product_detail_widgets/circle_icon.dart';
import '../product_detail_widgets/round_image.dart';
import '../product_detail_widgets/square_amount_box.dart';

class CheckoutProdItem extends StatelessWidget {
  const CheckoutProdItem({super.key});

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
                    height: Dimension.height8 / 2,
                  ),
                  Text(
                    'Size: Small',
                    style: TextStyle(
                        fontSize: Dimension.height12,
                        color: AppColors.greyTextColor,
                        height: 1.5),
                  ),
                  SizedBox(
                    height: Dimension.height8 / 2,
                  ),
                  Text(
                    '69.000 ₫',
                    style: AppText.style.boldBlack14,
                  ),
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
                      style: TextStyle(
                          fontSize: Dimension.height12,
                          color: AppColors.greyTextColor,
                          height: 1.5),
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height12,
                  ),

                  //Number add, minus
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleIcon(
                          isEnable: true,
                          icon: CupertinoIcons.minus,
                          backgroundColor: Colors.transparent,
                          onTap: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                      title: const Text(
                                        'Confirmation',
                                      ),
                                      content: Text(
                                        'Do you want to remove this product from your cart?',
                                        style: AppText.style.regular,
                                      ),
                                      actions: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Dimension.height8,
                                              horizontal: Dimension.height8),
                                          child: OutlinedButton(
                                            style: outlinedButton,
                                            onPressed: () =>
                                                Navigator.pop(context, 'Yes'),
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                  fontSize: Dimension.height16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Dimension.height8,
                                              horizontal: Dimension.height8),
                                          child: ElevatedButton(
                                            style: roundedButton,
                                            onPressed: () =>
                                                Navigator.pop(context, 'No'),
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                  fontSize: Dimension.height16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                          }),
                      SizedBox(
                        width: Dimension.height4,
                      ),
                      SquareAmountBox(
                          child: Text(
                        '1',
                        style: TextStyle(fontSize: Dimension.height16),
                      )),
                      SizedBox(
                        width: Dimension.height4,
                      ),
                      CircleIcon(
                          isEnable: true,
                          icon: CupertinoIcons.add,
                          backgroundColor: Colors.transparent,
                          onTap: () {}),
                    ],
                  ),
                  SizedBox(
                    height: Dimension.height12,
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
