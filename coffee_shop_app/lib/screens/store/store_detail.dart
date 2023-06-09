import 'dart:async';

import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_state.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../services/blocs/cart_button/cart_button_event.dart';
import '../../services/blocs/cart_button/cart_button_state.dart';
import '../../services/models/store.dart';
import '../../utils/constants/dimension.dart';
import '../../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../../widgets/feature/store/store_detail_card.dart';
import '../../widgets/feature/store/store_detail_skeleton.dart';
import '../../widgets/global/container_card.dart';
import '../../widgets/global/custom_app_bar.dart';

class StoreDetail extends StatefulWidget {
  static const String routeName = "/store_detail";
  const StoreDetail({super.key, required this.store});
  final Store store;

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  late StreamSubscription storeDetailSubscription;
  late Store? selectedStore;
  @override
  void initState() {
    selectedStore = widget.store;
    storeDetailSubscription =
        context.read<StoreStoreBloc>().stream.listen((state) {
      if (state is HasDataStoreStoreState) {
        if (selectedStore != null) {
          try {
            selectedStore = state.initStores
                .firstWhere((element) => element.id == selectedStore!.id);
          } catch (e) {
            selectedStore = null;
          }
          setState(() {
            selectedStore = selectedStore;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    storeDetailSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return selectedStore == null
        ? StoreDetailSkeleton()
        : ColoredBox(
            color: AppColors.backgroundColor,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    CustomAppBar(
                      color: Colors.white,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            StoreDetailCard(
                              store: selectedStore!,
                            ),
                            SizedBox(
                              height: Dimension.height12,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: Dimension.height16,
                                  right: Dimension.height16),
                              child: Column(
                                children: [
                                  BlocBuilder<CartButtonBloc, CartButtonState>(
                                      builder: (context, state) {
                                    return ContainerCard(
                                        verticalPadding: Dimension.height16,
                                        child: SizedBox(
                                          width: double.maxFinite,
                                          height: Dimension.height150,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                CartButtonBloc>(
                                                            context)
                                                        .add(ChangeSelectedStore(
                                                            selectedStore:
                                                                selectedStore!));
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            Dimension.width108,
                                                        height:
                                                            Dimension.height72,
                                                        child: Image.asset(
                                                          "assets/images/pickup_icon.png",
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            Dimension.height8,
                                                      ),
                                                      Text(
                                                        "Mang đi",
                                                        style: AppText.style
                                                            .mediumBlack16,
                                                      ),
                                                      Text(
                                                        "Phục vụ tốt nhất",
                                                        style: AppText.style
                                                            .regularGrey14,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimension.width16,
                                              ),
                                              Container(
                                                height: Dimension.height48,
                                                width: Dimension.width1,
                                                color: AppColors.greyBoxColor,
                                              ),
                                              SizedBox(
                                                width: Dimension.width16,
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                CartButtonBloc>(
                                                            context)
                                                        .add(ChangeSelectedStoreButNotUse(
                                                            selectedStore:
                                                                selectedStore!));
                                                    BlocProvider.of<
                                                                CartButtonBloc>(
                                                            context)
                                                        .add(ChangeSelectedOrderType(
                                                            selectedOrderType:
                                                                OrderType
                                                                    .delivery));
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            Dimension.width108,
                                                        height:
                                                            Dimension.height72,
                                                        child: Image.asset(
                                                          "assets/images/delivery_icon.png",
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            Dimension.height8,
                                                      ),
                                                      Text(
                                                        "Giao hàng",
                                                        style: AppText.style
                                                            .mediumBlack16,
                                                      ),
                                                      Text(
                                                        "Luôn đúng giờ",
                                                        style: AppText.style
                                                            .regularGrey14,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                  }),
                                  SizedBox(
                                    height: Dimension.height12,
                                  ),
                                  ContainerCard(
                                    horizontalPadding: Dimension.height16,
                                    verticalPadding: Dimension.height24,
                                    child: Column(
                                      children: [
                                        IconWidgetRow(
                                          icon: CupertinoIcons.phone_fill,
                                          iconColor: AppColors.greenColor,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Số điện thoại',
                                                style: AppText.style.regular,
                                              ),
                                              SizedBox(
                                                height: Dimension.height4,
                                              ),
                                              Text(
                                                selectedStore!.phone,
                                                style:
                                                    AppText.style.boldBlack14,
                                              )
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          color: AppColors.greyBoxColor,
                                        ),
                                        IconWidgetRow(
                                          icon: Icons.location_pin,
                                          iconColor: Colors.blue,
                                          child: Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Địa chỉ',
                                                  style: AppText.style.regular,
                                                ),
                                                SizedBox(
                                                  height: Dimension.height4,
                                                ),
                                                Text(
                                                  selectedStore!
                                                      .address.formattedAddress,
                                                  style:
                                                      AppText.style.boldBlack14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
