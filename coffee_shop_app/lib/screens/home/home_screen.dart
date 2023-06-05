import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_state.dart'
    as store_store_state;
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
import '../../widgets/global/custom_app_bar.dart';
import '../../widgets/global/order_type_picker.dart';
import '../../widgets/global/product_item.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final int durationChange = 500;
  final ScrollController scrollController = ScrollController();
  bool isScrollInTop = true;

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
    scrollController.addListener(() {
      if (scrollController.offset <= 0 && !isScrollInTop) {
        setState(() {
          isScrollInTop = true;
        });
      } else if (scrollController.offset > 0 && isScrollInTop) {
        setState(() {
          isScrollInTop = false;
        });
      }
    });

    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              children: [
                CustomAppBar(
                  color:
                      isScrollInTop ? AppColors.backgroundColor : Colors.white,
                  leading: Row(
                    crossAxisAlignment: isScrollInTop
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        height: Dimension.height40,
                        width: isScrollInTop ? Dimension.height40 : 0,
                        padding: const EdgeInsets.all(0),
                        duration: Duration(milliseconds: durationChange),
                        child: CircleAvatar(
                          radius: Dimension.height20,
                          backgroundColor: Color.fromARGB(255, 226, 226, 226),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: ClipOval(
                              child: AsyncImage(
                                src: AuthAPI.currentUser!.avatarUrl,
                                type: PlaceholderType.user,
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        width: isScrollInTop ? Dimension.width12 : 0,
                        duration: Duration(milliseconds: durationChange),
                      ),
                      Column(
                        mainAxisAlignment: isScrollInTop
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: durationChange),
                            height: isScrollInTop ? Dimension.height20 : 0,
                            child: Text(
                              "Chào mừng đến với",
                              style: AppText.style.regular,
                            ),
                          ),
                          AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: durationChange),
                            style: isScrollInTop
                                ? AppText.style.boldBlack14
                                : AppText.style.boldBlack18,
                            child: Text("K U P I"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListView(controller: scrollController, children: [
                        SizedBox(
                          height: Dimension.height24,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimension.width16),
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
                              return Column(
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
                                          return ProductItem(
                                            product:
                                                state.recentSeeProducts[index],
                                          );
                                        },
                                        itemCount:
                                            state.recentSeeProducts.length,
                                      ))
                                ],
                              );
                            } else if (state
                                is recent_see_state.NotExistState) {
                              return Container(
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
                                      BlocBuilder<
                                              CartButtonBloc,
                                              store_store_state
                                                  .CartButtonState>(
                                          builder: (context, state) {
                                        return ElevatedButton(
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
                                                style: AppText
                                                    .style.regularWhite16,
                                              ),
                                              Icon(Icons.coffee)
                                            ],
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                        SizedBox(
                          height: Dimension.height68,
                        )
                      ]),
                      CartButton(scrollController: scrollController)
                    ],
                  ),
                ),
              ],
            )));
  }
}
