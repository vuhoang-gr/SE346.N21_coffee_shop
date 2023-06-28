import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_state.dart';
import 'package:coffee_shop_app/widgets/global/aysncImage/async_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/apis/auth_api.dart';
import '../../services/blocs/recent_see_products/recent_see_products_bloc.dart';
import '../../services/blocs/recent_see_products/recent_see_products_event.dart';
import '../../services/blocs/recent_see_products/recent_see_products_state.dart'
    as recent_see_state;

import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/constants/placeholder_enum.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/feature/menu_screen/skeleton/product_fixed_skeleton.dart';
import '../../widgets/global/cart_button.dart';
import '../../widgets/global/order_type_picker.dart';
import '../../widgets/global/product_item.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int durationChange = 500;
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    RecentSeeProductsBloc recentSeeProductsBloc =
        BlocProvider.of<RecentSeeProductsBloc>(context);
    recentSeeProductsBloc.add(ListRecentSeeProductLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Stack(
              children: [
                ListView(controller: scrollController, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimension.width16,
                        vertical: Dimension.height8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: Dimension.height20,
                          backgroundColor: Color.fromARGB(255, 226, 226, 226),
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius:
                                BorderRadius.circular(Dimension.height20),
                            child: AsyncImage(
                              height: Dimension.height40,
                              width: Dimension.width40,
                              src: AuthAPI.currentUser!.avatarUrl,
                              type: PlaceholderType.user,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Dimension.width12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chào mừng đến với",
                              style: AppText.style.regular,
                            ),
                            Text(
                              "K U P I",
                              style: AppText.style.boldBlack14,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height24,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimension.width16),
                    child: const OrderTypePicker(),
                  ),
                  SizedBox(
                    height: Dimension.height24,
                  ),
                  BlocBuilder<RecentSeeProductsBloc,
                      recent_see_state.RecentSeeProductsState>(
                    builder: (context, state) {
                      if (state is recent_see_state.LoadingState) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimension.width16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Vừa xem",
                                style: AppText.style.boldBlack16,
                              ),
                              SizedBox(
                                height: Dimension.height12,
                              ),
                              ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (_, __) {
                                    return ProductFixedSkeleton();
                                  },
                                  separatorBuilder: (_, __) => SizedBox(
                                        height: Dimension.height16,
                                      ),
                                  itemCount: 5),
                            ],
                          ),
                        );
                      } else if (state is recent_see_state.LoadedState) {
                        return state.recentSeeProducts.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimension.width16),
                                    child: Text(
                                      "Vừa xem",
                                      style: AppText.style.boldBlack16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimension.height12,
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimension.width16),
                                      child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (ctx, index) {
                                          return SizedBox(
                                            height: Dimension.height8,
                                          );
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            margin: EdgeInsets.zero,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Dimension.height4,
                                                  horizontal: Dimension.width4),
                                              child: ProductItem(
                                                product: state
                                                    .recentSeeProducts[index],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount:
                                            state.recentSeeProducts.length,
                                      ))
                                ],
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white),
                                margin: EdgeInsets.symmetric(
                                  horizontal: Dimension.width16,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimension.width16,
                                    vertical: Dimension.height16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: Dimension.height24,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Dimension.width32,
                                          ),

                                          //link: https://storyset.com/illustration/cocktail-bartender/rafiki
                                          child: Image.asset(
                                              'assets/images/img_getting_started.png')),
                                      SizedBox(
                                        height: Dimension.height24,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          DefaultTabController.of(context)
                                              .animateTo(1);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Bắt đầu ",
                                              style:
                                                  AppText.style.regularWhite16,
                                            ),
                                            Icon(Icons.coffee)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(
                    height: Dimension.height68,
                  )
                ]),
                BlocBuilder<StoreStoreBloc, StoreStoreState>(
                    builder: (context, state) {
                  if (state is HasDataStoreStoreState) {
                    return CartButton(scrollController: scrollController);
                  } else {
                    return SizedBox.shrink();
                  }
                })
              ],
            )));
  }
}
