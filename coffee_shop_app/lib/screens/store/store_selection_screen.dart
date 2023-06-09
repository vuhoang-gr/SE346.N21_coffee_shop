import 'package:coffee_shop_app/screens/store/store_detail.dart';
import 'package:coffee_shop_app/screens/store/store_search_screen.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_state.dart';
import 'package:coffee_shop_app/services/models/store.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/feature/store/store_list_item.dart';
import '../../widgets/feature/store/store_skeleton.dart';
import '../../widgets/global/custom_app_bar.dart';

class StoreSelectionScreen extends StatefulWidget {
  static const routeName = "/store_selection_screen";
  final LatLng? latLng;
  final bool isPurposeForShowDetail;
  const StoreSelectionScreen(
      {super.key, required this.latLng, this.isPurposeForShowDetail = false});

  @override
  State<StoreSelectionScreen> createState() => _StoreSelectionScreenState();
}

class _StoreSelectionScreenState extends State<StoreSelectionScreen> {
  @override
  void didChangeDependencies() {
    BlocProvider.of<StoreStoreBloc>(context)
        .add(UpdateLocation(latLng: widget.latLng));
    super.didChangeDependencies();
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
                    'Cửa hàng',
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
                  child: GestureDetector(
                    onTap: () {
                      StoreStoreState storeState =
                          BlocProvider.of<StoreStoreBloc>(context).state;
                      if (storeState is HasDataStoreStoreState) {
                        Navigator.of(context)
                            .pushNamed(StoreSearchScreen.routeName, arguments: {
                          "latLng": widget.latLng,
                          "isPurposeForShowDetail":
                              widget.isPurposeForShowDetail,
                        }).then((value) {
                          if (value != null && value is bool && value == true) {
                            if (widget.isPurposeForShowDetail) {
                              //change to menu
                              DefaultTabController.of(context).index = 1;
                            } else {
                              Navigator.of(context).pop();
                            }
                          }
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: AppColors.greyBoxColor, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimension.height10,
                        horizontal: Dimension.width10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.search,
                            color: AppColors.greyTextColor,
                          ),
                          SizedBox(
                            width: Dimension.width10,
                          ),
                          Expanded(
                              child: Text(
                            "Tìm kiếm cửa hàng",
                            style: AppText.style.regularGrey14,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: BlocBuilder<StoreStoreBloc, StoreStoreState>(
                    builder: (context, state) {
                  if (state is HasDataStoreStoreState) {
                    return RefreshIndicator(onRefresh: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        BlocProvider.of<StoreStoreBloc>(context)
                            .add(FetchData(location: widget.latLng));
                      }
                    }, child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimension.width16,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  state.nearestStore != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "Gần nhất",
                                              style:
                                                  AppText.style.mediumBlack16,
                                            ),
                                            SizedBox(
                                              height: Dimension.height8,
                                            ),
                                            StoreListItem(
                                              store: state.nearestStore!,
                                              latLng: widget.latLng,
                                              tapHandler: _tapHandler(
                                                  state.nearestStore!,
                                                  widget
                                                      .isPurposeForShowDetail),
                                            ),
                                            SizedBox(
                                              height: Dimension.height16,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  state.listFavoriteStore.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "Yêu thích",
                                              style:
                                                  AppText.style.mediumBlack16,
                                            ),
                                            generateListView(
                                                state.listFavoriteStore),
                                            SizedBox(
                                              height: Dimension.height16,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  ((state.listFavoriteStore.isNotEmpty ||
                                              state.nearestStore != null) &&
                                          state.listOtherStore.isNotEmpty)
                                      ? Text(
                                          "Khác",
                                          style: AppText.style.mediumBlack16,
                                        )
                                      : SizedBox.shrink(),
                                  generateListView(state.listOtherStore),
                                  SizedBox(
                                    height: Dimension.height16,
                                  )
                                ]),
                          ),
                        ),
                      );
                    }));
                  } else if (state is LoadingState) {
                    return Padding(
                      padding: EdgeInsets.only(
                          right: Dimension.width16,
                          left: Dimension.width16,
                          top: Dimension.height16),
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
                          itemCount: 8),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                })),
              ],
            ),
          ),
        ));
  }

  Widget generateListView(List<Store> stores) {
    return ListView.separated(
      padding: EdgeInsets.only(top: Dimension.height8),
      itemCount: stores.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      controller: ScrollController(),
      itemBuilder: (context, index) {
        return StoreListItem(
          store: stores[index],
          latLng: widget.latLng,
          tapHandler: _tapHandler(stores[index], widget.isPurposeForShowDetail),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: Dimension.height12,
        );
      },
    );
  }

  VoidCallback _tapHandler(Store store, bool isPurposeForShowDetail) {
    VoidCallback tapHandler;
    if (isPurposeForShowDetail) {
      tapHandler = () {
        Navigator.of(context)
            .pushNamed(StoreDetail.routeName, arguments: store)
            .then((value) {
          if (value != null && value is bool && value == true) {
            //pop to menu
            DefaultTabController.of(context).index = 1;
          }
        });
      };
    } else {
      tapHandler = () {
        Navigator.of(context).pop(store);
      };
    }
    return tapHandler;
  }
}
