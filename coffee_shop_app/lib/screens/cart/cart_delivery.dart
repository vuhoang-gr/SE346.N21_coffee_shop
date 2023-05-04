import 'package:coffee_shop_app/services/blocs/cart_cubit/cart_cubit.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../services/blocs/cart_button/cart_button_event.dart';
import '../../services/blocs/cart_button/cart_button_state.dart';
import '../../services/functions/money_transfer.dart';
import '../../services/models/cart.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/button.dart';
import '../../widgets/feature/cart_delivery_pickup/apply_coupon_textfield.dart';
import '../../widgets/feature/cart_delivery_pickup/checkout_prod_item.dart';
import '../../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../../widgets/global/container_card.dart';
import '../../widgets/global/custom_app_bar.dart';
import '../../widgets/global/order_type_modal.dart';
import '../address_listing_screen.dart';

class CartDelivery extends StatelessWidget {
  const CartDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, Cart>(builder: (context, state) {
      double total = BlocProvider.of<CartCubit>(context).state.total!;
      double productTotal = BlocProvider.of<CartCubit>(context).state.total!;
      double deliveryCost =
          BlocProvider.of<CartCubit>(context).state.deliveryCost!;
      double discount = BlocProvider.of<CartCubit>(context).state.discount!;

      return ColoredBox(
        color: AppColors.backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  leading: Text('Cart', style: AppText.style.boldBlack18),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimension.height16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Dimension.height16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Shipping details',
                                  style: AppText.style.boldBlack16,
                                ),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (builder) {
                                        return OrderTypeModal();
                                      }).then((value) {
                                    if (BlocProvider.of<CartButtonBloc>(context)
                                            .state
                                            .selectedOrderType ==
                                        OrderType.storePickup) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              "/cart_store_pickup_screen");
                                    }
                                  }),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimension.height4,
                                        horizontal: Dimension.height12),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue, width: 1.2),
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.blueBackgroundColor),
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                          fontSize: Dimension.font12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Dimension.height8,
                            ),

                            //from store to address
                            BlocBuilder<CartButtonBloc, CartButtonState>(
                                builder: (context, state) {
                              return ContainerCard(
                                horizontalPadding: Dimension.height16,
                                verticalPadding: Dimension.height12 * 2,
                                child: Column(
                                  children: [
                                    IconWidgetRow(
                                      icon: Icons.store_rounded,
                                      child: Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'From store',
                                              style: AppText.style.regular,
                                            ),
                                            SizedBox(
                                              height: Dimension.height8 / 2,
                                            ),
                                            Text(
                                              '${state.selectedStore}',
                                              style: AppText.style.boldBlack14,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: AppColors.greyBoxColor,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: IconWidgetRow(
                                            icon: Icons.location_pin,
                                            iconColor: AppColors.greenColor,
                                            child: Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('To',
                                                      style: AppText
                                                          .style.regular),
                                                  SizedBox(
                                                    height: Dimension.height4,
                                                  ),
                                                  Text(
                                                      '${state.selectedDeliveryAddress?.address.toString()}',
                                                      style: AppText
                                                          .style.boldBlack14),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: AppText
                                                          .style.regularGrey12,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                '${state.selectedDeliveryAddress?.nameReceiver}'),
                                                        TextSpan(
                                                          text: ' • ',
                                                          style: AppText.style
                                                              .boldBlack14,
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                '${state.selectedDeliveryAddress?.phone}'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                AddressListingScreen.routeName);
                                          },
                                          icon: Icon(
                                            CupertinoIcons.right_chevron,
                                            size: Dimension.height20,
                                            color: AppColors.greyTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(
                              height: Dimension.height16,
                            ),

                            //oder details
                            Text(
                              'Order details',
                              style: AppText.style.boldBlack16,
                            ),
                            SizedBox(
                              height: Dimension.height8,
                            ),

                            ContainerCard(
                              horizontalPadding: Dimension.height16,
                              child: Column(
                                children: [
                                  ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      controller: ScrollController(),
                                      itemBuilder: (context, index) {
                                        return CheckoutProdItem(
                                          cartFood: BlocProvider.of<CartCubit>(
                                                  context)
                                              .state
                                              .products[index],
                                        );
                                      },
                                      separatorBuilder: (_, __) =>
                                          const Divider(
                                            thickness: 1,
                                            color: AppColors.greyBoxColor,
                                          ),
                                      itemCount:
                                          BlocProvider.of<CartCubit>(context)
                                              .state
                                              .products
                                              .length),
                                  const Divider(
                                    thickness: 1,
                                    color: AppColors.greyBoxColor,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Price',
                                          style: AppText.style.regularBlack14),
                                      Builder(builder: (context) {
                                        return Text(
                                          '${MoneyTransfer.transferFromDouble(productTotal)} ₫',
                                          style: AppText.style.boldBlack14,
                                        );
                                      }),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Shipping fee',
                                          style: AppText.style.regularBlack14),
                                      Text(
                                        '${MoneyTransfer.transferFromDouble(deliveryCost)} ₫',
                                        style: AppText.style.boldBlack14,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimension.height16,
                  ),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      //apply coupon
                      SizedBox(
                        height: Dimension.height40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconWidgetRow(
                                icon: Icons.discount_rounded,
                                iconColor: AppColors.greenColor,
                                size: Dimension.height12 * 2,
                                child: Text(
                                  'Apply coupon',
                                  style: AppText.style.boldBlack14,
                                )),
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.right_chevron,
                                size: Dimension.height20,
                                color: AppColors.greyTextColor,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (builder) {
                                      return SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: Dimension.height16,
                                              vertical: 0,
                                            ),
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 3,
                                                  blurRadius: 5,
                                                  offset: const Offset(0,
                                                      5), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: ApplyCouponTextfield(
                                              closeBox: () {
                                                Navigator.pop(context);
                                              },
                                            )),
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimension.height8),
                        child: SizedBox(
                          width: double.maxFinite,
                          height: Dimension.height40,
                          child: ElevatedButton(
                            style: roundedButton,
                            onPressed: () {},
                            child: Text(
                              'Pay ${MoneyTransfer.transferFromDouble(total)} ₫',
                              style: AppText.style.regularWhite16,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
