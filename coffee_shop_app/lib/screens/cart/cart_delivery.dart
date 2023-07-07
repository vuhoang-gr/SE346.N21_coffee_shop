import 'package:coffee_shop_app/screens/promo/promo_screen.dart';
import 'package:coffee_shop_app/services/blocs/cart_cubit/cart_cubit.dart';
import 'package:coffee_shop_app/services/functions/datetime_to_pickup.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/constants/shipping_value.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../services/blocs/cart_button/cart_button_event.dart';
import '../../services/blocs/cart_button/cart_button_state.dart';
import '../../services/functions/money_transfer.dart';
import '../../services/models/cart.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/button.dart';
import '../../widgets/feature/cart_delivery_pickup/checkout_prod_item.dart';
import '../../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../../widgets/global/container_card.dart';
import '../../widgets/global/custom_app_bar.dart';
import '../../widgets/global/order_type_modal.dart';
import '../customer_address/address_listing_screen.dart';

class CartDelivery extends StatelessWidget {
  const CartDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, Cart>(builder: (context, state) {
      double total = BlocProvider.of<CartCubit>(context).state.total!;
      double productTotal =
          BlocProvider.of<CartCubit>(context).state.totalFood!;
      return ColoredBox(
        color: AppColors.backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  leading: Text('Giỏ hàng', style: AppText.style.boldBlack18),
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
                                  'Thông tin giao hàng',
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
                                      'Thay đổi',
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
                                              'Từ cửa hàng',
                                              style: AppText.style.regular,
                                            ),
                                            SizedBox(
                                              height: Dimension.height8 / 2,
                                            ),
                                            Text(
                                              state.selectedStore!.address
                                                  .formattedAddress,
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
                                                  Text('Đến',
                                                      style: AppText
                                                          .style.regular),
                                                  SizedBox(
                                                    height: Dimension.height4,
                                                  ),
                                                  Text(
                                                      '${state.selectedDeliveryAddress == null ? 'Không có địa chỉ giao hàng' : state.selectedDeliveryAddress?.address.formattedAddress}',
                                                      style: AppText
                                                          .style.boldBlack14),
                                                  state.selectedDeliveryAddress ==
                                                          null
                                                      ? SizedBox.shrink()
                                                      : Text.rich(
                                                          TextSpan(
                                                            style: AppText.style
                                                                .regularGrey12,
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      '${state.selectedDeliveryAddress?.nameReceiver}'),
                                                              TextSpan(
                                                                text: ' • ',
                                                                style: AppText
                                                                    .style
                                                                    .regularGrey14,
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
                              'Chi tiết đơn hàng',
                              style: AppText.style.boldBlack16,
                            ),
                            SizedBox(
                              height: Dimension.height8,
                            ),

                            ContainerCard(
                              horizontalPadding: Dimension.height16,
                              child: state.products.isEmpty
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimension.height16),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            height: Dimension.height24,
                                          ),
                                          Image.asset(
                                            'assets/images/img_no_order.png',
                                            height: 120,
                                          ),
                                          SizedBox(
                                            height: Dimension.height24,
                                          ),
                                          Text(
                                            'Không có sản phẩm trong giỏ hàng',
                                            style: AppText.style.regularBlack16,
                                          ),
                                          SizedBox(
                                            height: Dimension.height24,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        BlocBuilder<CartCubit, Cart>(
                                            builder: (context, state) {
                                          return ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              controller: ScrollController(),
                                              itemBuilder: (context, index) {
                                                if (!state.products[index]
                                                        .isToppingAvailable ||
                                                    !state.products[index]
                                                        .isSizeAvailable ||
                                                    !state.products[index].food
                                                        .isAvailable) {
                                                  return Opacity(
                                                    opacity: 0.5,
                                                    child: CheckoutProdItem(
                                                      cartFood:
                                                          state.products[index],
                                                    ),
                                                  );
                                                } else {
                                                  return CheckoutProdItem(
                                                    cartFood: BlocProvider.of<
                                                            CartCubit>(context)
                                                        .state
                                                        .products[index],
                                                  );
                                                }
                                              },
                                              separatorBuilder: (_, __) =>
                                                  const Divider(
                                                    thickness: 1,
                                                    color:
                                                        AppColors.greyBoxColor,
                                                  ),
                                              itemCount:
                                                  BlocProvider.of<CartCubit>(
                                                          context)
                                                      .state
                                                      .products
                                                      .length);
                                        }),
                                        const Divider(
                                          thickness: 1,
                                          color: AppColors.greyBoxColor,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Tổng tiền',
                                                style: AppText
                                                    .style.regularBlack14),
                                            Builder(builder: (context) {
                                              return Text(
                                                '${MoneyTransfer.transferFromDouble(productTotal)} ₫',
                                                style:
                                                    AppText.style.boldBlack14,
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
                                            Text('Phí giao hàng',
                                                style: AppText
                                                    .style.regularBlack14),
                                            BlocBuilder<CartButtonBloc,
                                                    CartButtonState>(
                                                builder: (context, state) {
                                              var shippingFee = calShippingFee(
                                                  state.distance);
                                              BlocProvider.of<CartCubit>(
                                                      context)
                                                  .calculateTotalPrice(
                                                      deliveryCost:
                                                          shippingFee);
                                              return Text(
                                                '${MoneyTransfer.transferFromDouble(BlocProvider.of<CartCubit>(context).state.deliveryCost!)} ₫',
                                                style:
                                                    AppText.style.boldBlack14,
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
                                            Text('Giảm giá từ cửa hàng',
                                                style: AppText
                                                    .style.regularBlack14),
                                            Text(
                                              '-${MoneyTransfer.transferFromDouble(BlocProvider.of<CartCubit>(context).state.discount!)} ₫',
                                              style: AppText.style.boldBlack14
                                                  .copyWith(
                                                      color:
                                                          AppColors.greenColor),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              height: Dimension.height12,
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
                                  'Sử dụng mã giảm giá',
                                  style: AppText.style.boldBlack14,
                                )),
                            BlocBuilder<CartButtonBloc, CartButtonState>(
                                builder: (context, cartButtonState) {
                              return IconButton(
                                icon: Icon(
                                  CupertinoIcons.right_chevron,
                                  size: Dimension.height20,
                                  color: AppColors.greyTextColor,
                                ),
                                onPressed: () {
                                  //Mai: promo
                                  Navigator.of(context)
                                      .pushNamed(PromoScreen.routeName)
                                      .then((value) {
                                    BlocProvider.of<CartCubit>(context)
                                        .checkPromo(value,
                                            cartButtonState.selectedStore!);
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimension.height8),
                        child: SizedBox(
                          width: double.maxFinite,
                          height: Dimension.height40,
                          child: BlocBuilder<CartButtonBloc, CartButtonState>(
                              builder: (context, cartButtonState) {
                            return state.products.isEmpty ||
                                    cartButtonState.selectedDeliveryAddress ==
                                        null
                                ? ElevatedButton(
                                    style: roundedButton,
                                    onPressed: null,
                                    child: Text(
                                      'Đặt hàng ${MoneyTransfer.transferFromDouble(0)} ₫',
                                      style: AppText.style.regularWhite16,
                                    ))
                                : ElevatedButton(
                                    style: roundedButton,
                                    onPressed: () {
                                      var canOrder = BlocProvider.of<CartCubit>(
                                              context)
                                          .checkCanOrderFoods(
                                              store: BlocProvider.of<
                                                      CartButtonBloc>(context)
                                                  .state
                                                  .selectedStore!);
                                      if (!canOrder) {
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoAlertDialog(
                                                  title: const Text(
                                                    'Lỗi',
                                                  ),
                                                  content: Text(
                                                    'Có vài sản phẩm không hợp lệ trong giỏ hàng, vui lòng kiểm tra lại.',
                                                    style:
                                                        AppText.style.regular,
                                                  ),
                                                  actions: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  Dimension
                                                                      .height8,
                                                              horizontal:
                                                                  Dimension
                                                                      .height8),
                                                      child: OutlinedButton(
                                                        style: outlinedButton,
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK',
                                                            style: AppText.style
                                                                .regularBlack16
                                                                .copyWith(
                                                                    color: Colors
                                                                        .blue)),
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                      } else if (dateTimeToHour(
                                                  DateTime.now()) >
                                              dateTimeToHour(cartButtonState
                                                  .selectedStore!.timeClose) ||
                                          dateTimeToHour(DateTime.now()) <
                                              dateTimeToHour(cartButtonState
                                                  .selectedStore!.timeOpen)) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Không trong thời gian hoạt động, vui lòng quay lại sau.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            textColor: Colors.white,
                                            fontSize: Dimension.font14);
                                      } else {
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoAlertDialog(
                                                  title: const Text(
                                                    'Lưu ý',
                                                  ),
                                                  content: Text(
                                                    'Bạn sẽ không được huỷ đơn nếu xác nhận đặt hàng',
                                                    style:
                                                        AppText.style.regular,
                                                  ),
                                                  actions: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  Dimension
                                                                      .height8,
                                                              horizontal:
                                                                  Dimension
                                                                      .height8),
                                                      child: OutlinedButton(
                                                        style: outlinedButton,
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context, 'Yes');
                                                          await BlocProvider.of<
                                                                      CartCubit>(
                                                                  context)
                                                              .placeOrder(
                                                            store: BlocProvider
                                                                    .of<CartButtonBloc>(
                                                                        context)
                                                                .state
                                                                .selectedStore!,
                                                            address: BlocProvider
                                                                    .of<CartButtonBloc>(
                                                                        context)
                                                                .state
                                                                .selectedDeliveryAddress,
                                                          );
                                                        },
                                                        child: Text('Đặt hàng',
                                                            style: AppText.style
                                                                .regularBlack16
                                                                .copyWith(
                                                                    color: Colors
                                                                        .blue)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  Dimension
                                                                      .height8,
                                                              horizontal:
                                                                  Dimension
                                                                      .height8),
                                                      child: ElevatedButton(
                                                        style: roundedButton,
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Huỷ bỏ'),
                                                        child: Text('Huỷ bỏ',
                                                            style: AppText.style
                                                                .regularBlack16
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white)),
                                                      ),
                                                    ),
                                                  ],
                                                )).then((value) {
                                          if (value != null && value == 'Yes') {
                                            QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.success,
                                                text: 'Đặt hàng thành công',
                                                confirmBtnText: 'OK',
                                                onConfirmBtnTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                });
                                          }
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Đặt hàng ${MoneyTransfer.transferFromDouble(total)} ₫',
                                      style: AppText.style.regularWhite16,
                                    ),
                                  );
                          }),
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
