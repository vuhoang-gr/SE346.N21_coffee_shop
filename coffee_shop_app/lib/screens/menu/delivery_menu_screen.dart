import 'package:coffee_shop_app/screens/search_product_screen.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_state.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_state.dart';
import 'package:coffee_shop_app/widgets/feature/menu_screen/skeleton/delivery_menu_skeleton.dart';
import 'package:coffee_shop_app/widgets/global/cart_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../services/blocs/product_store/product_store_event.dart';
import '../../services/blocs/store_store/store_store_bloc.dart';
import '../../services/blocs/store_store/store_store_state.dart' as store_state;
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/feature/menu_screen/address_picker.dart';
import '../../widgets/feature/menu_screen/delivery_store_picker.dart';
import '../../widgets/global/custom_app_bar.dart';
import '../../widgets/global/product_item.dart';

class DeliveryMenuScreen extends StatefulWidget {
  const DeliveryMenuScreen({super.key});

  @override
  State<DeliveryMenuScreen> createState() => _DeliveryMenuScreenState();
}

class _DeliveryMenuScreenState extends State<DeliveryMenuScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.offset <= Dimension.height82 && _isButtonVisible) {
        setState(() {
          _isButtonVisible = false;
        });
      } else if (_scrollController.offset > Dimension.height82 &&
          !_isButtonVisible) {
        setState(() {
          _isButtonVisible = true;
        });
      }
    });

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(
            leading: Text(
              "Giao hàng",
              style: AppText.style.boldBlack18,
            ),
            trailing: BlocBuilder<ProductStoreBloc, ProductStoreState>(
                builder: (context, state) {
              if (state is HasDataProductStoreState) {
                return IconButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(SearchProductScreen.routeName),
                    icon: Icon(Icons.search));
              } else {
                return SizedBox.shrink();
              }
            }),
          ),
          Expanded(
            child: Stack(
              children: [
                BlocBuilder<ProductStoreBloc, ProductStoreState>(
                    builder: (context, state) {
                  if (state is HasDataProductStoreState) {
                    _isButtonVisible = false;
                    return RefreshIndicator(
                      onRefresh: () async {
                        if (FirebaseAuth.instance.currentUser != null) {
                          CartButtonState cartButtonState =
                              BlocProvider.of<CartButtonBloc>(context).state;
                          BlocProvider.of<ProductStoreBloc>(context).add(
                              FetchData(
                                  stateFood: cartButtonState
                                      .selectedStore?.stateFood));
                        }
                      },
                      child: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: ListView(
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            children: [
                              AddressPicker(),
                              SizedBox(height: Dimension.height8),
                              const DeliveryStorePicker(),
                              SizedBox(height: Dimension.height8),
                              state.listFavoriteFood.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 12, 0, 12),
                                      child: Text(
                                        "Yêu thích",
                                        style: AppText.style.mediumBlack14,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              ...(state.listFavoriteFood
                                  .map((product) => Container(
                                        padding: EdgeInsets.only(
                                            bottom: Dimension.height8,
                                            left: Dimension.width16,
                                            right: Dimension.width16),
                                        child: (ProductItem(
                                          product: product,
                                        )),
                                      ))
                                  .toList()),
                              (state.listFavoriteFood.isNotEmpty &&
                                      state.listOtherFood.isNotEmpty)
                                  ? Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 12, 0, 12),
                                      child: Text(
                                        "Khác",
                                        style: AppText.style.mediumBlack14,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              ...(state.listOtherFood
                                  .map((product) => Container(
                                        padding: EdgeInsets.only(
                                            bottom: Dimension.height8,
                                            left: Dimension.width16,
                                            right: Dimension.width16),
                                        child: (ProductItem(
                                          product: product,
                                        )),
                                      ))
                                  .toList()),
                              SizedBox(
                                height: Dimension.height68,
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  } else if (state is LoadingState || state is FetchedState) {
                    return DeliveryMenuSkeleton();
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                _isButtonVisible
                    ? Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: Dimension.height8,
                            ),
                            color: Colors.white,
                            child: const DeliveryStorePicker()))
                    : SizedBox.shrink(),
                BlocBuilder<StoreStoreBloc, store_state.StoreStoreState>(
                    builder: (context, state) {
                  if (state is store_state.HasDataStoreStoreState) {
                    return CartButton(scrollController: _scrollController);
                  } else {
                    return SizedBox.shrink();
                  }
                })
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
