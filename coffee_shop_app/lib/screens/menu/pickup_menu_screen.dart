import 'package:coffee_shop_app/screens/search_product_screen.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_event.dart';
import 'package:coffee_shop_app/widgets/feature/menu_screen/skeleton/pickup_menu_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/product_store/product_store_state.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/feature/menu_screen/pickup_store_picker.dart';
import '../../widgets/global/cart_button.dart';
import '../../widgets/global/custom_app_bar.dart';
import '../../widgets/global/product_item.dart';

class PickupMenuScreen extends StatefulWidget {
  const PickupMenuScreen({super.key});

  @override
  State<PickupMenuScreen> createState() => _PickupMenuScreenState();
}

class _PickupMenuScreenState extends State<PickupMenuScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductStoreBloc>(context).add(FetchData());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          CustomAppBar(
              leading: Text(
                "Store pickup",
                style: AppText.style.boldBlack18,
              ),
              trailing: BlocBuilder<ProductStoreBloc, ProductStoreState>(
                  builder: (context, state) {
                if (state is LoadedState) {
                  return IconButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(SearchProductScreen.routeName),
                      icon: Icon(Icons.search));
                } else {
                  return SizedBox.shrink();
                }
              })),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: BlocBuilder<ProductStoreBloc, ProductStoreState>(
                  builder: (context, state) {
                if (state is LoadedState) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<ProductStoreBloc>(context)
                              .add(FetchData());
                        },
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            const PickupStorePicker(),
                            SizedBox(height: Dimension.height8),
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                              child: Text(
                                "Favorite",
                                style: AppText.style.mediumBlack14,
                              ),
                            ),
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
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                              child: Text(
                                "Other",
                                style: AppText.style.mediumBlack14,
                              ),
                            ),
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
                      ),
                      CartButton(scrollController: _scrollController),
                    ],
                  );
                } else if (state is LoadingState) {
                  return PickupMenuSkeleton();
                } else {
                  return SizedBox.shrink();
                }
              }),
            ),
          ),
        ],
      ),
    ));
  }
}
