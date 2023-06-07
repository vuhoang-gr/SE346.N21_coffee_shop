import 'package:coffee_shop_app/services/models/cart_food.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/blocs/cart_cubit/cart_cubit.dart';
import '../../../services/functions/money_transfer.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/button.dart';
import '../product_detail_widgets/circle_icon.dart';
import '../product_detail_widgets/round_image.dart';
import '../product_detail_widgets/square_amount_box.dart';

class CheckoutProdItem extends StatelessWidget {
  const CheckoutProdItem({super.key, required this.cartFood});
  final CartFood cartFood;
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
            RoundImage(imgUrl: cartFood.food.images[0]),
            SizedBox(
              width: Dimension.height8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartFood.food.name,
                    style: AppText.style.boldBlack14,
                  ),
                  SizedBox(
                    height: Dimension.height8 / 2,
                  ),

                  // TODO: fix this
                  // Text(
                  //   'Size: ${cartFood.food.sizes!.firstWhere((size) => size.id == cartFood.size).name}',
                  //   style: AppText.style.regularGrey12,
                  // ),
                  
                  SizedBox(
                    height: Dimension.height8 / 2,
                  ),
                  cartFood.topping == ''
                      ? SizedBox.shrink()
                      : Text(
                          'Topping: ${cartFood.topping}',
                          style: AppText.style.regularGrey12,
                        ),
                  SizedBox(
                    height: Dimension.height8 / 2,
                  ),

                  //price
                  Text(
                    '${MoneyTransfer.transferFromDouble(cartFood.unitPrice * cartFood.quantity)} ₫',
                    style: AppText.style.boldBlack14,
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  cartFood.note == null || cartFood.note!.isEmpty
                      ? SizedBox()
                      : SizedBox(
                          width: double.infinity,
                          child: Container(
                            padding: EdgeInsets.all(Dimension.height8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppColors.greyTextField)),
                            child: Text(cartFood.note!,
                                style: AppText.style.regularGrey12),
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
                            if (cartFood.quantity > 1) {
                              BlocProvider.of<CartCubit>(context)
                                  .updateQuantityFromCart(
                                      cartFood, cartFood.quantity - 1);
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      //minus to 0 dialog
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
                                              onPressed: () {
                                                BlocProvider.of<CartCubit>(
                                                        context)
                                                    .updateQuantityFromCart(
                                                        cartFood,
                                                        cartFood.quantity - 1);
                                                Navigator.pop(context, 'Yes');
                                              },
                                              child: Text('Yes',
                                                  style: AppText
                                                      .style.regularBlack16
                                                      .copyWith(
                                                          color: Colors.blue)),
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
                                              child: Text('No',
                                                  style: AppText
                                                      .style.regularBlack16
                                                      .copyWith(
                                                          color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      )).then((value) {
                                if (BlocProvider.of<CartCubit>(context)
                                    .state
                                    .products
                                    .isEmpty) {
                                  Navigator.of(context).pop();
                                  // Navigator.of(context)
                                  //     .pushReplacementNamed("/");
                                }
                              });
                            }
                          }),
                      SizedBox(
                        width: Dimension.height4,
                      ),
                      SquareAmountBox(
                          child: Text(cartFood.quantity.toString(),
                              style: AppText.style.regularBlack16)),
                      SizedBox(
                        width: Dimension.height4,
                      ),
                      CircleIcon(
                          isEnable: true,
                          icon: CupertinoIcons.add,
                          backgroundColor: Colors.transparent,
                          onTap: () {
                            BlocProvider.of<CartCubit>(context)
                                .updateQuantityFromCart(
                                    cartFood, cartFood.quantity + 1);
                          }),
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
