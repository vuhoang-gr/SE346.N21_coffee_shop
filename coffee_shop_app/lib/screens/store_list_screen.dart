import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants/dimension.dart';
import '../widgets/feature/store/store_list_item.dart';
import '../widgets/global/custom_app_bar.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen(
      {super.key, this.hasFavoriteStore = false, this.notFoundStore = false});
  final bool hasFavoriteStore;
  final bool notFoundStore;

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  String newString = "";
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
        color: widget.notFoundStore ? Colors.white : AppColors.backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  leading: Text(
                    'Stores',
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
                          setState(() {
                            newString = newText;
                          });
                        },
                        controller: _controller,
                        focusNode: _focus,
                        style: AppText.style.regularBlack14,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(CupertinoIcons.search),
                            suffixIcon: newString.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _controller.clear();
                                      setState(() {
                                        newString = "";
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
                            if (widget.notFoundStore) {
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
                                    SizedBox(
                                      height: Dimension.height8,
                                    ),
                                    Builder(builder: (context) {
                                      if (widget.hasFavoriteStore) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: Dimension.height8,
                                            ),
                                            Text(
                                              'Favorite stores',
                                              style: AppText.style.boldBlack16,
                                            ),
                                            ListView.separated(
                                              padding: EdgeInsets.only(
                                                  top: Dimension.height8),
                                              itemCount: 3,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              controller: ScrollController(),
                                              itemBuilder: (context, index) {
                                                return const StoreListItem();
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: Dimension.height12,
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              height: Dimension.height16,
                                            ),
                                            Text(
                                              'Other stores',
                                              style: AppText.style.boldBlack16,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),

                                    // all stores
                                    ListView.separated(
                                      padding: EdgeInsets.only(
                                          top: Dimension.height8),
                                      itemCount: 20,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      controller: ScrollController(),
                                      itemBuilder: (context, index) {
                                        return const StoreListItem();
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: Dimension.height12,
                                        );
                                      },
                                    ),
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
