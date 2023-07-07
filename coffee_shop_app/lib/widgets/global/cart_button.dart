import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/blocs/cart_button/cart_button_state.dart';
import '../../services/functions/money_transfer.dart';
import '../../services/models/cart.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import 'order_type_modal.dart';

class CartButton extends StatefulWidget {
  final ScrollController scrollController;
  const CartButton({super.key, required this.scrollController});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  int timeChange = 500;
  bool _isShowAll = true;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController;
  }

  scrollListener() {
    if (scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        _isShowAll) {
      setState(() {
        _isShowAll = false;
      });
    } else if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        !_isShowAll) {
      setState(() {
        _isShowAll = true;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(scrollListener);

    return Positioned(
      bottom: Dimension.height8,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (builder) {
            return OrderTypeModal();
          },
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimension.width16, vertical: Dimension.height8),
          child: BlocBuilder<CartButtonBloc, CartButtonState>(
              builder: (context, cartButtonState) {
            return cartButtonState.selectedOrderType == OrderType.delivery
                ? AnimatedContainer(
                    duration: Duration(milliseconds: timeChange),
                    height:
                        _isShowAll ? Dimension.height56 : Dimension.height40,
                    width: Dimension.width296,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimension.width8,
                        vertical: Dimension.height8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.greyIconColor,
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                            offset: Offset(
                              0,
                              Dimension
                                  .height8, // Move to bottom 8.0 Vertically
                            ))
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: Duration(milliseconds: timeChange),
                                bottom: _isShowAll ? Dimension.height20 : 0,
                                top: 0,
                                left: 0,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: timeChange),
                                  height: _isShowAll
                                      ? Dimension.height20
                                      : Dimension.height32,
                                  width: _isShowAll
                                      ? Dimension.height20
                                      : Dimension.height32,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/delivery_small_icon.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: Dimension.height20,
                                left: Dimension.width24,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: timeChange),
                                  opacity: _isShowAll ? 1 : 0,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Giao hàng đến",
                                      style: AppText.style.mediumGrey12,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                duration: Duration(milliseconds: timeChange),
                                bottom: 0,
                                left: _isShowAll ? 0 : Dimension.height32,
                                right: 0,
                                top: _isShowAll ? Dimension.height20 : 0,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    cartButtonState
                                            .selectedDeliveryAddress?.address.formattedAddress??
                                        "Món ăn sẽ được giao tới bạn",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.style.mediumBlack12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<CartCubit, Cart>(builder: (context, state) {
                          return BlocProvider.of<CartCubit>(context)
                                  .state
                                  .products
                                  .isNotEmpty
                              ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (cartButtonState.selectedOrderType ==
                                        OrderType.delivery) {
                                      Navigator.of(context)
                                          .pushNamed("/cart_delivery_screen");
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          "/cart_store_pickup_screen");
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: Dimension.width8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.blueColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: AnimatedPadding(
                                          duration: Duration(
                                              milliseconds: timeChange),
                                          padding: _isShowAll
                                              ? EdgeInsets.symmetric(
                                                  horizontal: Dimension.width8,
                                                  vertical: Dimension.height6)
                                              : EdgeInsets.symmetric(
                                                  horizontal: Dimension.width4,
                                                  vertical: Dimension.height4),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: Dimension.height16,
                                                width: Dimension.height16,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimension.height8)),
                                                child: Center(
                                                  child: Text(
                                                    BlocProvider.of<CartCubit>(
                                                            context)
                                                        .state
                                                        .products
                                                        .map((e) => e.quantity)
                                                        .reduce(
                                                            (value, element) =>
                                                                value + element)
                                                        .toString(),
                                                    style: AppText
                                                        .style.mediumBlue12
                                                        .copyWith(height: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimension.width4,
                                              ),
                                              Text(
                                                "${MoneyTransfer.transferFromDouble(BlocProvider.of<CartCubit>(context).state.total ?? 0)}đ",
                                                style:
                                                    AppText.style.mediumWhite12,
                                              ),
                                              SizedBox(
                                                width: Dimension.width4,
                                              ),
                                              IconTheme(
                                                data: IconThemeData(
                                                  size: Dimension.height10,
                                                ),
                                                child: const FaIcon(
                                                  FontAwesomeIcons.chevronRight,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimension.width2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink();
                        }),
                      ],
                    ),
                  )
                : AnimatedContainer(
                    duration: Duration(milliseconds: timeChange),
                    height:
                        _isShowAll ? Dimension.height56 : Dimension.height40,
                    width: Dimension.width296,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimension.width8,
                        vertical: Dimension.height8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.greyIconColor,
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                            offset: Offset(
                              0,
                              Dimension
                                  .height8, // Move to bottom 8.0 Vertically
                            ))
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: Duration(milliseconds: timeChange),
                                bottom: _isShowAll ? Dimension.height20 : 0,
                                top: 0,
                                left: 0,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: timeChange),
                                  height: _isShowAll
                                      ? Dimension.height20
                                      : Dimension.height32,
                                  width: _isShowAll
                                      ? Dimension.height20
                                      : Dimension.height32,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/pickup_small_icon.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: Dimension.height20,
                                left: Dimension.width24,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: timeChange),
                                  opacity: _isShowAll ? 1 : 0,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Tới lấy tại",
                                      style: AppText.style.mediumGrey12,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                duration: Duration(milliseconds: timeChange),
                                bottom: 0,
                                left: _isShowAll ? 0 : Dimension.height32,
                                right: 0,
                                top: _isShowAll ? Dimension.height20 : 0,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    cartButtonState.selectedStore?.address
                                            .formattedAddress ??
                                        "Tới cửa hàng lấy món ăn và mang đi",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.style.mediumBlack12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<CartCubit, Cart>(builder: (context, state) {
                          return BlocProvider.of<CartCubit>(context)
                                  .state
                                  .products
                                  .isNotEmpty
                              ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (cartButtonState.selectedOrderType ==
                                        OrderType.delivery) {
                                      Navigator.of(context)
                                          .pushNamed("/cart_delivery_screen");
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          "/cart_store_pickup_screen");
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: Dimension.width8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.blueColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: AnimatedPadding(
                                          duration: Duration(
                                              milliseconds: timeChange),
                                          padding: _isShowAll
                                              ? EdgeInsets.symmetric(
                                                  horizontal: Dimension.width8,
                                                  vertical: Dimension.height6)
                                              : EdgeInsets.symmetric(
                                                  horizontal: Dimension.width4,
                                                  vertical: Dimension.height4),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: Dimension.height16,
                                                width: Dimension.height16,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimension.height8)),
                                                child: Text(
                                                  BlocProvider.of<CartCubit>(
                                                          context)
                                                      .state
                                                      .products
                                                      .map((e) => e.quantity)
                                                      .reduce(
                                                          (value, element) =>
                                                              value + element)
                                                      .toString(),
                                                  style: AppText
                                                      .style.mediumBlue12,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimension.width4,
                                              ),
                                              Text(
                                                "${MoneyTransfer.transferFromDouble(BlocProvider.of<CartCubit>(context).state.totalFood ?? 0)}đ",
                                                style:
                                                    AppText.style.mediumWhite12,
                                              ),
                                              SizedBox(
                                                width: Dimension.width4,
                                              ),
                                              IconTheme(
                                                data: IconThemeData(
                                                  size: Dimension.height10,
                                                ),
                                                child: const FaIcon(
                                                  FontAwesomeIcons.chevronRight,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimension.width2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink();
                        }),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
