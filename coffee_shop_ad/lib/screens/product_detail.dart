import 'package:coffee_shop_admin/services/models/topping.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/functions/money_transfer.dart';
import '../services/models/drink.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../utils/styles/button.dart';
import '../widgets/feature/product_detail_widgets/circle_icon.dart';
import '../widgets/feature/product_detail_widgets/product_card.dart';
import '../widgets/feature/product_detail_widgets/round_image.dart';
import '../widgets/feature/product_detail_widgets/square_amount_box.dart';
import '../widgets/global/custom_app_bar.dart';
import '../services/models/size.dart';

class ProductDetail extends StatefulWidget {
  final Drink product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var _selectedToppings = [];
  var _selectedSize;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();

    _selectedSize = widget.product.sizes![0];

    _selectedToppings =
        List<bool>.generate(widget.product.toppings!.length, (index) => false);
    _totalPrice = widget.product.price + widget.product.sizes![0].price;
    //number to add
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ColoredBox(
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    color: AppColors.backgroundColor,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    children: [
                      ProductCard(product: widget.product),

                      //size
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimension.height16,
                            vertical: Dimension.height16),
                        margin: EdgeInsets.only(
                            top: Dimension.height12,
                            left: Dimension.height16,
                            right: Dimension.height16),
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  controller: ScrollController(),
                                  itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          setState(() {
                                            double prevSizePrice =
                                                (_selectedSize as Size).price;
                                            _selectedSize =
                                                widget.product.sizes![index];
                                            _totalPrice = _totalPrice -
                                                prevSizePrice +
                                                widget.product.sizes![index]
                                                    .price;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Radio<Size>(
                                                  value: widget
                                                      .product.sizes![index],
                                                  groupValue: _selectedSize,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      double prevSizePrice =
                                                          (_selectedSize
                                                                  as Size)
                                                              .price;
                                                      _selectedSize = value;
                                                      _totalPrice =
                                                          _totalPrice -
                                                              prevSizePrice +
                                                              value!.price;
                                                    });
                                                  },
                                                ),
                                                RoundImage(
                                                    imgUrl: widget.product
                                                        .sizes![index].image),
                                                SizedBox(
                                                  width: Dimension.height8,
                                                ),
                                                Text(
                                                  widget.product.sizes![index]
                                                      .name,
                                                  style: AppText
                                                      .style.regularBlack14,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '+${MoneyTransfer.transferFromDouble(widget.product.sizes![index].price)} ₫',
                                              style: AppText.style.boldBlack14,
                                            ),
                                          ],
                                        ),
                                      ),
                                  separatorBuilder: (_, __) => const Divider(
                                        thickness: 2,
                                        color: AppColors.greyBoxColor,
                                      ),
                                  itemCount: widget.product.sizes!.length),
                            ]),
                      ),

                      //topping
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimension.height16,
                            vertical: Dimension.height16),
                        margin: EdgeInsets.only(
                            top: Dimension.height12,
                            left: Dimension.height16,
                            right: Dimension.height16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: AppText.style.boldBlack16,
                                children: <TextSpan>[
                                  const TextSpan(text: 'Topping '),
                                  TextSpan(
                                    text: '(maximum 2)',
                                    style: AppText.style.regularGrey14,
                                  )
                                ],
                              ),
                            ),
                            ListView.separated(
                                padding:
                                    EdgeInsets.only(top: Dimension.height16),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                controller: ScrollController(),
                                itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedToppings[index] =
                                              !_selectedToppings[index];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _selectedToppings[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedToppings[index] =
                                                        value;
                                                  });
                                                },
                                              ),
                                              RoundImage(
                                                  imgUrl: widget.product
                                                      .toppings![index].image),
                                              SizedBox(
                                                width: Dimension.height8,
                                              ),
                                              Text(
                                                  widget.product
                                                      .toppings![index].name,
                                                  style: AppText
                                                      .style.regularBlack14),
                                            ],
                                          ),
                                          Text(
                                            '+${MoneyTransfer.transferFromDouble(widget.product.toppings![index].price)} ₫',
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                    ),
                                separatorBuilder: (_, __) => const Divider(
                                      thickness: 2,
                                      color: AppColors.greyBoxColor,
                                    ),
                                itemCount: widget.product.toppings!.length),
                          ],
                        ),
                      ),

                      SizedBox(height: 16)
                    ],
                  ))),

                  //add to cart bar
                  isKeyboard
                      ? const SizedBox()
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimension.height16,
                              vertical: Dimension.height8),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height: Dimension.height40,
                                child: Builder(builder: (context) {
                                  return ElevatedButton(
                                      style: roundedButton,
                                      onPressed: () {},
                                      child: Text(
                                        'Delete',
                                        style: AppText.style.regularWhite16,
                                      ));
                                }),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
