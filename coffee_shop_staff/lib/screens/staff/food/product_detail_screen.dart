import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop_staff/services/apis/store_api.dart';
import 'package:coffee_shop_staff/services/blocs/product/product_bloc.dart';
import 'package:coffee_shop_staff/services/models/food_checker.dart';
import 'package:coffee_shop_staff/services/models/store_product.dart';
import 'package:coffee_shop_staff/widgets/global/aysncImage/async_image.dart';
import 'package:coffee_shop_staff/widgets/global/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../services/models/food.dart';
import '../../../services/models/store.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';
import '../../../widgets/global/custom_app_bar.dart';
import '../../../widgets/global/round_image.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = 'product_detail_screen/';
  final StoreProduct product;

  ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentIndex = 0;
  late FoodChecker product;
  late Food productRaw;
  late List<bool> _selectedSizes;
  final Store store = StoreAPI.currentStore!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product as FoodChecker;
    productRaw = widget.product.item as Food;
    _selectedSizes = [];
    for (int i = 0; i < productRaw.sizes!.length; i++) {
      var item = productRaw.sizes![i];
      if (product.blockSize == null || product.blockSize!.isEmpty) {
        _selectedSizes.add(true);
        continue;
      }
      if (product.blockSize!.contains(item.id)) {
        _selectedSizes.add(false);
      } else {
        _selectedSizes.add(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onSaveProduct() async {
      product.isStocking = _selectedSizes.contains(true) ? true : false;
      if (product.isStocking) {
        product.blockSize = [];
        for (int i = 0; i < _selectedSizes.length; i++) {
          if (!_selectedSizes[i]) {
            product.blockSize!.add(productRaw.sizes![i].id);
          }
        }
      }

      await StoreAPI().update(store);
      if (context.mounted) {
        context
            .read<ProductBloc>()
            .add(ChangeProduct(product: store.stateFood));
      }
      return;
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Back button
                Navigator.of(context).canPop()
                    ? CustomAppBar(
                        leading: Text(
                          productRaw.name,
                          style: AppText.style.regularBlack16,
                        ),
                      )
                    : SizedBox(
                        height: Dimension.height32,
                      ),
                //body
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimension.getWidthFromValue(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Header
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 269.0,
                              autoPlay: true,
                              aspectRatio: 2,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                            items: productRaw.images.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return AsyncImage(src: i);
                                },
                              );
                            }).toList(),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: DotsIndicator(
                              dotsCount: productRaw.images.length,
                              position: currentIndex,
                            ),
                          ),

                          //Size
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimension.height16,
                                vertical: Dimension.height16),
                            margin: EdgeInsets.only(
                              top: Dimension.height12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Size",
                                    style: AppText.style.boldBlack16,
                                  ),
                                  ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      controller: ScrollController(),
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {
                                              setState(() {
                                                _selectedSizes[index] =
                                                    !_selectedSizes[index];
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      value:
                                                          _selectedSizes[index],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _selectedSizes[
                                                                  index] =
                                                              value ?? false;
                                                        });
                                                      },
                                                    ),
                                                    RoundImage(
                                                        imgUrl: productRaw
                                                            .sizes![index]
                                                            .image),
                                                    SizedBox(
                                                      width: Dimension.height8,
                                                    ),
                                                    Text(
                                                      productRaw
                                                          .sizes![index].name,
                                                      style: AppText
                                                          .style.regularBlack14,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '+${NumberFormat("#,##0", "en_US").format(productRaw.sizes![index].price)} ₫',
                                                  style: AppText
                                                      .style.mediumBlack14,
                                                ),
                                              ],
                                            ),
                                          ),
                                      separatorBuilder: (_, __) =>
                                          const Divider(
                                            thickness: 2,
                                            color: AppColors.greyBoxColor,
                                          ),
                                      itemCount: productRaw.sizes!.length),
                                ]),
                          ),

                          //Footer
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.white.withOpacity(0),
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: RoundedButton(
                    onPressed: onSaveProduct,
                    label: 'Save',
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
