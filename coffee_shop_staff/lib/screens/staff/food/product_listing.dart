import 'package:coffee_shop_staff/screens/staff/food/product_detail_screen.dart';
import 'package:coffee_shop_staff/services/apis/store_api.dart';
import 'package:coffee_shop_staff/services/models/food_checker.dart';
import 'package:coffee_shop_staff/services/models/store_product.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:coffee_shop_staff/widgets/global/custom_checkbox.dart';
import 'package:coffee_shop_staff/widgets/global/textForm/custom_text_form.dart';
import 'package:flutter/material.dart';

import '../../../services/models/store.dart';
import '../../../utils/constants/dimension.dart';
import '../../../widgets/features/product_screen/product_card.dart';

class ProductListing extends StatefulWidget {
  const ProductListing({super.key, required this.itemList});
  final List<StoreProduct> itemList;

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  late List<StoreProduct> itemList;
  TextEditingController findTextController = TextEditingController(text: '');
  List<StoreProduct> searchList = [];
  List<StoreProduct> _tempList = [];

  //filter
  bool available = false;
  bool unavailable = false;
  bool isSemi = false;

  @override
  void initState() {
    super.initState();
    itemList = widget.itemList;
    searchList = itemList;
    _tempList = searchList;
  }

  @override
  Widget build(BuildContext context) {
    void onSearch(String filter) {
      if (filter.isEmpty) {
        setState(() {
          searchList = itemList;
        });
        _tempList = searchList;
      }
      var newList = itemList
          .where((element) => (element.item.name as String)
              .toLowerCase()
              .contains(filter.toLowerCase()))
          .toList();
      setState(() {
        searchList = newList;
      });
      _tempList = searchList;
    }

    bool semiCheck(StoreProduct item) {
      return item is FoodChecker &&
          item.blockSize!.isNotEmpty &&
          item.isStocking;
    }

    void onFilter() {
      var newList = _tempList.where((element) {
        bool preCheck = false;
        if (isSemi) {
          bool check = semiCheck(element);
          if (!available && !unavailable) {
            return check;
          }
          preCheck = check;
        }
        if (available && !unavailable) {
          return element.isStocking || preCheck;
        } else if (available && unavailable) {
          return true;
        } else if (!available && unavailable) {
          return !element.isStocking || preCheck;
        } else if (!available && !unavailable) {
          return true;
        }
        return true;
      }).toList();
      setState(() {
        searchList = newList;
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Column(
                children: [
                  CustormTextForm(
                    controller: findTextController,
                    label: 'Tìm kiếm sản phẩm',
                    prefixIcon: Icon(Icons.search),
                    onChanged: onSearch,
                    canCancel: true,
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomCheckBox(
                          value: available,
                          onChanged: (value) {
                            setState(() {
                              available = !available;
                            });
                            onFilter();
                          },
                          title: Text(
                            'Còn hàng',
                            style: AppText.style.regularBlack14,
                          ),
                        ),
                        CustomCheckBox(
                          value: unavailable,
                          // margin: EdgeInsets.only(left: 10),
                          onChanged: (value) {
                            setState(() {
                              unavailable = !unavailable;
                            });
                            onFilter();
                          },
                          title: Text(
                            'Hết hàng',
                            style: AppText.style.regularBlack14,
                          ),
                        ),
                        itemList[0] is FoodChecker
                            ? CustomCheckBox(
                                value: isSemi,
                                // margin: EdgeInsets.only(left: 10),
                                onChanged: (value) {
                                  setState(() {
                                    isSemi = !isSemi;
                                  });
                                  onFilter();
                                },
                                title: Text(
                                  'Thiếu size',
                                  style: AppText.style.regularBlack14,
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: searchList[index],
                      onPressed: () {
                        if (searchList[index] is FoodChecker) {
                          Navigator.of(context).pushNamed(
                              ProductDetailScreen.routeName,
                              arguments: searchList[index]);
                        }
                      },
                      onDoFunction: () async {
                        Store temp = StoreAPI.currentStore!;
                        if (searchList[index] is FoodChecker) {
                          temp.stateFood =
                              itemList.map((e) => e as FoodChecker).toList();
                        } else {
                          temp.stateTopping = itemList;
                        }
                        await StoreAPI().update(temp);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: Dimension.height12,
                    );
                  },
                  itemCount: searchList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
