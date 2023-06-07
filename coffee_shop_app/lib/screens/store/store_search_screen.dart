import 'dart:async';

import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/search_store/search_store_state.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/blocs/search_store/search_store_event.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/feature/store/store_list_item.dart';
import '../../widgets/feature/store/store_skeleton.dart';
import '../../widgets/global/custom_app_bar.dart';

class StoreSearchScreen extends StatefulWidget {
  static const routeName = "/store_search_screen";
  final LatLng? latLng;
  final bool isPurposeForShowDetail;
  const StoreSearchScreen(
      {super.key, required this.latLng, this.isPurposeForShowDetail = false});

  @override
  State<StoreSearchScreen> createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  Timer? _debounce;
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchStoreBloc>(context).add(UpdateList(
        listStore: BlocProvider.of<StoreStoreBloc>(context).state.initStores));
    _streamSubscription = BlocProvider.of<StoreStoreBloc>(context)
        .stream
        .listen((storeStoreState) {
      if (storeStoreState is FetchedState) {
        BlocProvider.of<SearchStoreBloc>(context)
            .add(UpdateList(listStore: storeStoreState.initStores));
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
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  leading: Text(
                    'Chọn cửa hàng',
                    style: AppText.style.boldBlack18,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: Dimension.height16,
                      bottom: Dimension.height16,
                      right: Dimension.width4),
                  color: Colors.white,
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
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
                              hintText: 'Tìm kiếm cửa hàng',
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
                      ),
                      SizedBox(
                        width: Dimension.width8,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            "Hủy",
                            style: AppText.style.regularBlue14,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimension.height16,
                        ),
                        child: BlocBuilder<SearchStoreBloc, SearchStoreState>(
                          builder: (context, state) {
                            if (state is EmptyListStore) {
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
                            } else if (state is LoadedListStore) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.separated(
                                      padding: EdgeInsets.only(
                                          top: Dimension.height16),
                                      itemCount:
                                          state.searchStoreResults.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      controller: ScrollController(),
                                      itemBuilder: (context, index) {
                                        VoidCallback tapHandler;
                                        if (widget.isPurposeForShowDetail) {
                                          tapHandler = () {
                                            Navigator.of(context).pushNamed(
                                                "/store_detail",
                                                arguments: state
                                                    .searchStoreResults[index]);
                                          };
                                        } else {
                                          tapHandler = () {
                                            Navigator.of(context).pop(true);
                                            context.read<CartButtonBloc>().add(
                                                ChangeSelectedStoreButNotUse(
                                                    selectedStore: state
                                                            .searchStoreResults[
                                                        index]));
                                          };
                                        }
                                        return StoreListItem(
                                          store:
                                              state.searchStoreResults[index],
                                          latLng: widget.latLng,
                                          tapHandler: tapHandler,
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
                            } else if (state is LoadingListStore) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimension.width16,
                                      vertical: Dimension.height16),
                                  child: ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (_, __) {
                                        return StoreSkeleton();
                                      },
                                      separatorBuilder: (_, __) {
                                        return SizedBox(
                                          height: Dimension.height12,
                                        );
                                      },
                                      itemCount: 8));
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
        ));
  }
}
