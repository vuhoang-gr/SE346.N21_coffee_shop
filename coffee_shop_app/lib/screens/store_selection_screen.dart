import 'dart:async';

import 'package:coffee_shop_app/services/blocs/search_store/search_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/blocs/search_store/search_store_event.dart';
import '../utils/colors/app_colors.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../widgets/feature/store/temp_store_list_item.dart';
import '../widgets/global/custom_app_bar.dart';

class StoreSelectionScreen extends StatefulWidget {
  static const routeName = "/store_selection_screen";

  const StoreSelectionScreen({super.key});

  @override
  State<StoreSelectionScreen> createState() => _StoreSelectionScreenState();
}

class _StoreSelectionScreenState extends State<StoreSelectionScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocBuilder<SearchStoreBloc, SearchStoreState>(
          builder: (context, state) {
        return ColoredBox(
          color: state.searchStoreResults.isEmpty
              ? Colors.white
              : AppColors.backgroundColor,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    leading: Text(
                      'Select store',
                      style: AppText.style.boldBlack18,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: Dimension.height16,
                        right: Dimension.height16,
                        bottom: Dimension.height16),
                    color: Colors.white,
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onChanged: (String newText) {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }
                            _debounce = Timer(Duration(milliseconds: 500), () {
                              BlocProvider.of<SearchStoreBloc>(context)
                                  .add(SearchTextChanged(searchText: newText));
                            });
                          },
                          controller: BlocProvider.of<SearchStoreBloc>(context)
                              .controller,
                          onSubmitted: (value) {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }
                            BlocProvider.of<SearchStoreBloc>(context)
                                .add(SearchTextChanged(searchText: value));
                          },
                          style: AppText.style.regularBlack14,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(CupertinoIcons.search),
                              suffixIcon: BlocProvider.of<SearchStoreBloc>(
                                          context)
                                      .controller
                                      .text
                                      .isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        BlocProvider.of<SearchStoreBloc>(
                                                context)
                                            .add(SearchClear());
                                      },
                                      icon: const Icon(CupertinoIcons.clear))
                                  : const SizedBox.shrink(),
                              contentPadding: EdgeInsets.only(
                                  top: Dimension.height8,
                                  left: Dimension.height16,
                                  right: Dimension.height16),
                              hintText: 'Search store',
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimension.height16,
                          ),
                          child: Builder(
                            builder: (context) {
                              if (state.searchStoreResults.isEmpty) {
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
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Builder(builder: (context) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: Dimension.height16,
                                            ),
                                            state.searchFavoritesStoreResults
                                                    .isNotEmpty
                                                ? Text(
                                                    'Favorite stores',
                                                    style: AppText
                                                        .style.boldBlack16,
                                                  )
                                                : SizedBox.shrink(),
                                            ListView.separated(
                                              padding: EdgeInsets.only(
                                                  top: Dimension.height8),
                                              itemCount: state
                                                  .searchFavoritesStoreResults
                                                  .length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              controller: ScrollController(),
                                              itemBuilder: (context, index) {
                                                return TempStoreListItem(
                                                  isFavoriteStore: true,
                                                  store: state
                                                          .searchFavoritesStoreResults[
                                                      index],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: Dimension.height12,
                                                );
                                              },
                                            ),
                                            state.searchFavoritesStoreResults
                                                    .isNotEmpty
                                                ? SizedBox(
                                                    height: Dimension.height16,
                                                  )
                                                : SizedBox.shrink(),
                                            Text(
                                              'Other stores',
                                              style: AppText.style.boldBlack16,
                                            ),
                                          ],
                                        );
                                      }),

                                      // all stores
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
                                          return TempStoreListItem(
                                            store:
                                                state.searchStoreResults[index],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: Dimension.height12,
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: Dimension.height16,
                                      )
                                    ]);
                              }
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
