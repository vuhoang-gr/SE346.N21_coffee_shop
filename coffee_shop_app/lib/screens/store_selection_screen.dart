import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/models/store.dart';
import '../temp/data.dart';
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
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;

  List<Store> listStores = Data.storeAddress;
  List<Store> favoriteStores = Data.favoriteStores;

  void searchStore(String keyword) {
    List<Store> tempStores = Data.storeAddress
        .where((store) =>
            store.sb.contains(keyword) ||
            store.address.toString().contains(keyword))
        .toList();
    List<Store> tempFavoriteStores = Data.favoriteStores
        .where((store) =>
            store.sb.contains(keyword) ||
            store.address.toString().contains(keyword))
        .toList();

    setState(() {
      listStores = tempStores;
      favoriteStores = tempFavoriteStores;
    });
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _debounce?.cancel();
    _controller.dispose();
  }

  void _onFocusChange() {
    print("Focus: ${_focus.hasFocus.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ColoredBox(
        color: listStores.isEmpty ? Colors.white : AppColors.backgroundColor,
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
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(Duration(milliseconds: 500), () {
                            searchStore(newText);
                          });
                        },
                        controller: _controller,
                        focusNode: _focus,
                        onSubmitted: (value) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          searchStore(value);
                        },
                        style: AppText.style.regularBlack14,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(CupertinoIcons.search),
                            suffixIcon: _controller.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _controller.clear();
                                      _debounce = Timer(
                                          Duration(milliseconds: 500), () {
                                        searchStore("");
                                      });
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
                            if (listStores.isEmpty) {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Builder(builder: (context) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: Dimension.height16,
                                          ),
                                          favoriteStores.isNotEmpty
                                              ? Text(
                                                  'Favorite stores',
                                                  style:
                                                      AppText.style.boldBlack16,
                                                )
                                              : SizedBox.shrink(),
                                          ListView.separated(
                                            padding: EdgeInsets.only(
                                                top: Dimension.height8),
                                            itemCount: favoriteStores.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            controller: ScrollController(),
                                            itemBuilder: (context, index) {
                                              return TempStoreListItem(
                                                isFavoriteStore: true,
                                                address: favoriteStores[index]
                                                    .address
                                                    .toString(),
                                                shortName:
                                                    favoriteStores[index].sb,
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return SizedBox(
                                                height: Dimension.height12,
                                              );
                                            },
                                          ),
                                          favoriteStores.isNotEmpty
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
                                      itemCount: listStores.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      controller: ScrollController(),
                                      itemBuilder: (context, index) {
                                        return TempStoreListItem(
                                          address: listStores[index]
                                              .address
                                              .toString(),
                                          shortName: listStores[index].sb,
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
      ),
    );
  }
}
