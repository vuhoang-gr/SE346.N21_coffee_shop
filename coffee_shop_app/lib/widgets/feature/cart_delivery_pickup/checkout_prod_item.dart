import 'package:coffee_shop_app/services/models/cart_food.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../../services/blocs/cart_cubit/cart_cubit.dart';
import '../../../services/blocs/product_detail/product_detail_bloc.dart';
import '../../../services/blocs/product_detail/product_detail_event.dart';
import '../../../services/functions/money_transfer.dart';
import '../../../services/models/store.dart';
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
    return Dismissible(
      key: Key(cartFood.id.toString()),
      onDismissed: (direction) {
        BlocProvider.of<CartCubit>(context).updateQuantityFromCart(cartFood, 0);
      },
      direction: DismissDirection.endToStart,
      background: ColoredBox(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete_rounded,
              color: AppColors.redColor,
            ),
            Text(
              ' Xóa',
              style: TextStyle(
                color: AppColors.redColor,
                fontSize: Dimension.font14,
              ),
            ),
          ],
        ),
      ),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimension.height8,
            ),
            GestureDetector(
              onTap: () {
                Store? store =
                    context.read<CartButtonBloc>().state.selectedStore;
                context.read<ProductDetailBloc>().add(InitProduct(
                    selectedProduct: cartFood.food,
                    bannedSize: store?.stateFood[cartFood.food.id] ?? [],
                    bannedTopping: store?.stateTopping ?? []));
                Navigator.of(context).pushNamed("/product_detail_screen");
              },
              child: Row(
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
                        !cartFood.food.isAvailable
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: Dimension.height8 / 2,
                                  ),
                                  Text('Cửa hàng không có sẵn',
                                      style: AppText.style.regularGrey12
                                          .copyWith(color: AppColors.redColor)),
                                  SizedBox(
                                    height: Dimension.height8 / 2,
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: Dimension.height8 / 2,
                        ),
                        Builder(builder: (context) {
                          if (!cartFood.isSizeAvailable) {
                            return Text(
                              'Size được chọn đã hết',
                              style: AppText.style.regularGrey12
                                  .copyWith(color: AppColors.redColor),
                            );
                          } else {
                            return Text(
                              'Size: ${BlocProvider.of<CartCubit>(context).getCartFoodSize(cartFood)}',
                              style: AppText.style.regularGrey12,
                            );
                          }
                        }),
                        SizedBox(
                          height: Dimension.height8 / 2,
                        ),
                        cartFood.topping == ''
                            ? SizedBox.shrink()
                            : Builder(builder: (context) {
                                if (!cartFood.isToppingAvailable) {
                                  return Text(
                                    'Topping được chọn đã hết',
                                    style: AppText.style.regularGrey12
                                        .copyWith(color: AppColors.redColor),
                                  );
                                } else {
                                  return Text(
                                    'Topping: ${BlocProvider.of<CartCubit>(context).getCartFoodTopping(cartFood)}',
                                    style: AppText.style.regularGrey12,
                                  );
                                }
                              }),
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
                                      border: Border.all(
                                          color: AppColors.greyTextField)),
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
                                onTap: () async {
                                  if (cartFood.quantity > 1) {
                                    await BlocProvider.of<CartCubit>(context)
                                        .updateQuantityFromCart(
                                            cartFood, cartFood.quantity - 1);
                                  } else {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            //minus to 0 dialog
                                            CupertinoAlertDialog(
                                              title: const Text(
                                                'Xác nhận',
                                              ),
                                              content: Text(
                                                'Bạn muốn xoá sản phẩm khỏi giỏ hàng?',
                                                style: AppText.style.regular,
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          Dimension.height8,
                                                      horizontal:
                                                          Dimension.height8),
                                                  child: OutlinedButton(
                                                    style: outlinedButton,
                                                    onPressed: () async {
                                                      Navigator.pop(
                                                          context, 'Yes');
                                                      await BlocProvider.of<
                                                                  CartCubit>(
                                                              context)
                                                          .updateQuantityFromCart(
                                                              cartFood,
                                                              cartFood.quantity -
                                                                  1);
                                                    },
                                                    child: Text('Yes',
                                                        style: AppText.style
                                                            .regularBlack16
                                                            .copyWith(
                                                                color: Colors
                                                                    .blue)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          Dimension.height8,
                                                      horizontal:
                                                          Dimension.height8),
                                                  child: ElevatedButton(
                                                    style: roundedButton,
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'No'),
                                                    child: Text('No',
                                                        style: AppText.style
                                                            .regularBlack16
                                                            .copyWith(
                                                                color: Colors
                                                                    .white)),
                                                  ),
                                                ),
                                              ],
                                            )).then((value) {});
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
                                onTap: () async {
                                  await BlocProvider.of<CartCubit>(context)
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
