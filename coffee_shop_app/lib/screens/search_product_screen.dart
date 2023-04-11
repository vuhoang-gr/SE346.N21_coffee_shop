import 'dart:async';

import 'package:coffee_shop_app/services/models/food.dart';
import 'package:coffee_shop_app/widgets/global/product_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../temp/data.dart';
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
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;

  List<Food> allFoods = List.empty(growable: true);
  List<Food> listFoods = List.empty(growable: true);

  void searchStore(String keyword) {
    List<Food> tempFood =
        allFoods.where((food) => food.name.contains(keyword)).toList();

    setState(() {
      listFoods = tempFood;
    });
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    allFoods.addAll(Data.products);
    allFoods.removeWhere((food) =>
        Data.favoriteProducts.any((element) => element.id == food.id));
    allFoods = [...Data.favoriteProducts, ...allFoods];
    listFoods = allFoods;
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
        color: Colors.white,
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
                            Expanded(
                                child: Text("Store address",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: AppText.style.regular)),
                          ])),
                      SizedBox(
                        height: Dimension.height8,
                      ),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimension.height16,
                        ),
                        child: Builder(
                          builder: (context) {
                            if (listFoods.isEmpty) {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Dimension.height12,
                                    ),
                                    _controller.text.isEmpty
                                        ? Text(
                                            'Popular drinks and food',
                                            style: AppText.style.boldBlack16,
                                          )
                                        : SizedBox.shrink(),
                                    ListView.separated(
                                      padding: EdgeInsets.only(
                                          top: Dimension.height8),
                                      itemCount: listFoods.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      controller: ScrollController(),
                                      itemBuilder: (context, index) {
                                        return ProductItem(
                                            id: listFoods[index].id,
                                            productName: listFoods[index].name,
                                            productPrice:
                                                listFoods[index].price,
                                            imageProduct:
                                                listFoods[index].images[0],
                                            dateRegister:
                                                DateTime(2023, 3, 27, 12, 12));
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
  }
}
