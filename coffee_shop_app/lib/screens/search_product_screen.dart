import 'dart:async';

import 'package:coffee_shop_app/screens/store_selection_screen.dart';
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
import '../utils/colors/app_colors.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../widgets/global/custom_app_bar.dart';

class SearchProductScreen extends StatefulWidget {
  static const routeName = "/search_product_screen";

  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
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
                      'Search',
                      style: AppText.style.boldBlack18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(StoreSelectionScreen.routeName),
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
                                        CartButtonState>(
                                    builder: (context, state) {
                                  return Text(
                                      state.selectedStore?.address.toString() ??
                                          "Select the store",
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
                                hintText: 'What are you craving for?',
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
                              if (state.searchResults.isEmpty) {
                                return Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/img_store_not_found.png",
                                      width: 200,
                                      height: 200,
                                    ),
                                    Text(
                                      'Sorry, we nearly found it!',
                                      style: AppText.style.boldBlack16,
                                    ),
                                    Text(
                                      'Please try again, better luck next time',
                                      style: AppText.style.regular,
                                    ),
                                  ],
                                );
                              } else {
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
                                          ? Text(
                                              'Popular drinks and food',
                                              style: AppText.style.boldBlack16,
                                            )
                                          : SizedBox.shrink(),
                                      ListView.separated(
                                        padding: EdgeInsets.only(
                                            top: Dimension.height8),
                                        itemCount: state.searchResults.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        controller: ScrollController(),
                                        itemBuilder: (context, index) {
                                          return ProductItem(
                                              id: state.searchResults[index].id,
                                              productName: state
                                                  .searchResults[index].name,
                                              productPrice: state
                                                  .searchResults[index].price,
                                              imageProduct: state
                                                  .searchResults[index]
                                                  .images[0],
                                              dateRegister: DateTime(
                                                  2023, 3, 27, 12, 12));
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
