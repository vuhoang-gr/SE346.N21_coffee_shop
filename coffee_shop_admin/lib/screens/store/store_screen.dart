import 'package:coffee_shop_admin/screens/store/store_create.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_state.dart';
import 'package:coffee_shop_admin/services/models/store.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/styles/button.dart';
import 'package:coffee_shop_admin/widgets/feature/store/store_list_item.dart';
import 'package:coffee_shop_admin/widgets/feature/store/store_skeleton.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = "/store_selection_screen";
  final bool isPurposeForShowDetail = false;
  const StoreScreen({super.key, isPurposeForShowDetail = false});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StoreStoreBloc>(context).add(FetchData());
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
                    'Store',
                    style: AppText.style.boldBlack18,
                  ),
                ),
                Expanded(child: BlocBuilder<StoreStoreBloc, StoreStoreState>(builder: (context, state) {
                  if (state is LoadedState) {
                    print("loaded");
                    return RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<StoreStoreBloc>(context).add(FetchData());
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimension.width16,
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              SizedBox(
                                height: Dimension.height16,
                              ),
                              ElevatedButton(
                                  style: roundedButton,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(CreateStoreScreen.routeName);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'New Store',
                                        style: AppText.style.regularWhite16,
                                      )
                                    ],
                                  )),
                              generateListView(state.stores),
                              SizedBox(
                                height: Dimension.height16,
                              )
                            ]),
                          ),
                        ));
                  } else if (state is LoadingState) {
                    print("loading");

                    return Padding(
                      padding:
                          EdgeInsets.only(right: Dimension.width16, left: Dimension.width16, top: Dimension.height16),
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
                    print("err");
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
    tapHandler = () {
      Navigator.of(context).pushNamed("/store_detail", arguments: store);
    };
    return tapHandler;
  }
}
