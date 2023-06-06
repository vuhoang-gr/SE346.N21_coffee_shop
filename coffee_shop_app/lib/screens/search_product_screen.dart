import 'dart:async';

import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/screens/store/store_selection_screen.dart';
import 'package:coffee_shop_app/services/apis/food_api.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/product_store/product_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_event.dart';
import 'package:coffee_shop_app/services/blocs/search_product/search_product_state.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/widgets/global/product_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/blocs/cart_button/cart_button_state.dart';
import '../services/blocs/product_store/product_store_state.dart';
import '../services/models/store.dart';
import '../utils/colors/app_colors.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../widgets/feature/menu_screen/skeleton/product_skeleton.dart';
import '../widgets/global/custom_app_bar.dart';

class SearchProductScreen extends StatefulWidget {
  static const routeName = "/search_product_screen";

  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  Timer? _debounce;
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchProductBloc>(context).add(UpdateList(
        initListFood: FoodAPI().currentFoods));

    _streamSubscription = BlocProvider.of<ProductStoreBloc>(context)
        .stream
        .listen((productStoreState) {
      if (productStoreState is FetchedState) {
        BlocProvider.of<SearchProductBloc>(context)
            .add(UpdateList(initListFood: FoodAPI().currentFoods));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchProductBloc, SearchProductState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ColoredBox(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    leading: Text(
                      'Tìm kiếm',
                      style: AppText.style.boldBlack18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(StoreSelectionScreen.routeName, arguments: {
                      "latLng": initLatLng,
                      "isPurposeForShowDetail": false,
                    }).then((value) {
                      if (value != null && value is Store) {
                        BlocProvider.of<SearchProductBloc>(context)
                            .add(WaitingUpdateList());
                        BlocProvider.of<CartButtonBloc>(context).add(
                            ChangeSelectedStoreButNotUse(selectedStore: value));
                      }
                    }),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: Dimension.height16,
                          right: Dimension.height16,
                          bottom: Dimension.height16),
                      color: Colors.white,
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimension.height8),
                              child: Row(children: [
                                IconTheme(
                                  data: IconThemeData(
                                    size: Dimension.width20,
                                    color: AppColors.greyTextColor,
                                  ),
                                  child: const FaIcon(FontAwesomeIcons.store),
                                ),
                                SizedBox(
                                  width: Dimension.width8,
                                ),
                                Expanded(child: BlocBuilder<CartButtonBloc,
                                    CartButtonState>(builder: (context, state) {
                                  return Text(
                                      state.selectedStore?.address
                                              .formattedAddress ??
                                          "Chọn cửa hàng",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: AppText.style.regular);
                                })),
                              ])),
                          SizedBox(
                            height: Dimension.height8,
                          ),
                          TextField(
                            onChanged: (String newText) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              _debounce =
                                  Timer(Duration(milliseconds: 500), () {
                                BlocProvider.of<SearchProductBloc>(context).add(
                                    SearchTextChanged(searchText: newText));
                              });
                            },
                            onSubmitted: (value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              BlocProvider.of<SearchProductBloc>(context)
                                  .add(SearchTextChanged(searchText: value));
                            },
                            controller:
                                BlocProvider.of<SearchProductBloc>(context)
                                    .controller,
                            style: AppText.style.regularBlack14,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(CupertinoIcons.search),
                                suffixIcon: BlocProvider.of<SearchProductBloc>(
                                            context)
                                        .controller
                                        .text
                                        .isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          _debounce = Timer(
                                              Duration(milliseconds: 500), () {
                                            BlocProvider.of<SearchProductBloc>(
                                                    context)
                                                .add(SearchClear());
                                          });
                                        },
                                        icon: const Icon(CupertinoIcons.clear))
                                    : const SizedBox.shrink(),
                                contentPadding: EdgeInsets.only(
                                    top: Dimension.height8,
                                    left: Dimension.height16,
                                    right: Dimension.height16),
                                hintText: 'Bạn đang muốn ăn gì?',
                                hintStyle: AppText.style.regularGrey14,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide:
                                        const BorderSide(color: Colors.black)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: AppColors.greyTextField))),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimension.height16,
                          ),
                          child: Builder(
                            builder: (context) {
                              if (state is EmptyListFood) {
                                return Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/img_store_not_found.png",
                                      width: 200,
                                      height: 200,
                                    ),
                                    Text(
                                      'Xin lỗi, chúng tôi đã gần tìm thấy!',
                                      style: AppText.style.boldBlack16,
                                    ),
                                    Text(
                                      'Xin hãy thử lại, chúc bạn may mắn.',
                                      style: AppText.style.regular,
                                    ),
                                  ],
                                );
                              } else if (state is LoadedListFood) {
                                return Builder(builder: (context) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BlocProvider.of<SearchProductBloc>(
                                                  context)
                                              .controller
                                              .text
                                              .isEmpty
                                          ? Column(
                                              children: [
                                                Text(
                                                  'Món nước ưu chuộng',
                                                  style:
                                                      AppText.style.boldBlack16,
                                                ),
                                                SizedBox(
                                                  height: Dimension.height12,
                                                ),
                                              ],
                                            )
                                          : SizedBox.shrink(),
                                      ListView.separated(
                                        padding: EdgeInsets.only(
                                            top: Dimension.height8),
                                        itemCount:
                                            state.searchStoreResults.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        controller: ScrollController(),
                                        itemBuilder: (context, index) {
                                          return ProductItem(
                                            product:
                                                state.searchStoreResults[index],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: Dimension.height16,
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: Dimension.height16,
                                      ),
                                    ],
                                  );
                                });
                              } else if (state is LoadingListFood) {
                                return ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (_, __) {
                                      return ProductSkeleton();
                                    },
                                    separatorBuilder: (_, __) => SizedBox(
                                          height: Dimension.height16,
                                        ),
                                    itemCount: 5);
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
