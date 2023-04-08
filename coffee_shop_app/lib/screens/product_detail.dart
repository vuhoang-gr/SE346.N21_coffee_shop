import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../temp/model_temp.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../utils/styles/button.dart';
import '../widgets/feature/product_detail_widgets/circle_icon.dart';
import '../widgets/feature/product_detail_widgets/product_card.dart';
import '../widgets/feature/product_detail_widgets/round_image.dart';
import '../widgets/feature/product_detail_widgets/square_amount_box.dart';
import '../widgets/global/custom_app_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final listSize = <DrinkSize>[];
  final listTopping = <Topping>[];
  late var _selectedToppings;
  var _selectedSize;
  int _numberToAdd = 1;

  bool isEnable = true;

  @override
  void initState() {
    super.initState();

    //size values
    listSize.add(DrinkSize(size: 'Small'));
    listSize.add(DrinkSize(
        increasePrice: '10.000',
        size: 'Large',
        image:
            'https://product.hstatic.net/1000075078/product/cold-brew-sua-tuoi_379576_7fd130b7d162497a950503207876ef64.jpg'));

    _selectedSize = listSize[0];

    //topping values
    listTopping
        .add(Topping(name: 'Espresso (1 shot)', increasePrice: '10.000'));
    listTopping.add(Topping(
      name: 'Caramel',
      image:
          'https://product.hstatic.net/1000075078/product/1645969436_caramel-macchiato-nong-lifestyle-1_187d60b2a52244c58a5c2fd24addef78.jpg',
    ));

    _selectedToppings =
        List<bool>.generate(listTopping.length, (index) => false);

    //number to add
    _numberToAdd = 1;
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
                      const ProductCard(),

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
                                            _selectedSize = listSize[index];
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Radio<DrinkSize>(
                                                  value: listSize[index],
                                                  groupValue: _selectedSize,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedSize = value;
                                                    });
                                                  },
                                                ),
                                                RoundImage(
                                                    imgUrl:
                                                        listSize[index].image),
                                                SizedBox(
                                                  width: Dimension.height8,
                                                ),
                                                Text(
                                                  listSize[index].size,
                                                  style: AppText.style.regularBlack14,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '+${listSize[index].increasePrice} ₫',
                                              style: AppText.style.boldBlack14,
                                            ),
                                          ],
                                        ),
                                      ),
                                  separatorBuilder: (_, __) => const Divider(
                                        thickness: 2,
                                        color: AppColors.greyBoxColor,
                                      ),
                                  itemCount: listSize.length),
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
                                      style: AppText.style.regularGrey14,)
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
                                                  imgUrl:
                                                      listTopping[index].image),
                                              SizedBox(
                                                width: Dimension.height8,
                                              ),
                                              Text(
                                                listTopping[index].name,
                                                style: AppText.style.regularBlack14
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '+${listTopping[index].increasePrice} ₫',
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                    ),
                                separatorBuilder: (_, __) => const Divider(
                                      thickness: 2,
                                      color: AppColors.greyBoxColor,
                                    ),
                                itemCount: listSize.length),
                          ],
                        ),
                      ),

                      //note to barista
                      Container(
                          height: Dimension.height8 * 15,
                          width: double.maxFinite,
                          padding: EdgeInsets.only(
                              left: Dimension.height16,
                              right: Dimension.height16,
                              top: Dimension.height16,
                              bottom: Dimension.height8),
                          margin: EdgeInsets.only(
                              top: Dimension.height12,
                              left: Dimension.height16,
                              right: Dimension.height16,
                              bottom: Dimension.height16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            scrollPadding:
                                EdgeInsets.only(bottom: Dimension.height16),
                            textAlignVertical: TextAlignVertical.top,
                            expands: true,
                            maxLength: 100,
                            style: AppText.style.regularBlack14,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: Dimension.height8,
                                    left: Dimension.height16,
                                    right: Dimension.height16),
                                hintText: 'Your note to barista',
                                hintStyle: AppText.style.regularGrey14,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: AppColors.greyTextColor)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: AppColors.greyBoxColor))),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          )),
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
                          height: Dimension.addToCart108,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleIcon(
                                      isEnable: isEnable,
                                      icon: CupertinoIcons.minus,
                                      backgroundColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          _numberToAdd--;
                                          if (_numberToAdd == 0) {
                                            isEnable = false;
                                          }
                                        });
                                      }),
                                  SizedBox(
                                    width: Dimension.height8 / 2,
                                  ),
                                  SquareAmountBox(
                                      child: Text(
                                    '$_numberToAdd',
                                    style:AppText.style.regularBlack16,
                                  )),
                                  SizedBox(
                                    width: Dimension.height8 / 2,
                                  ),
                                  CircleIcon(
                                      isEnable: true,
                                      icon: CupertinoIcons.add,
                                      backgroundColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          _numberToAdd++;
                                          if (_numberToAdd > 0 && !isEnable) {
                                            isEnable = true;
                                          }
                                        });
                                      }),
                                ],
                              ),
                              SizedBox(
                                height: Dimension.height8,
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                height: Dimension.height40,
                                child: ElevatedButton(
                                  style: roundedButton,
                                  onPressed: () {},
                                  child: Text(
                                    'Add to cart - 69.000 ₫',
                                    style: AppText.style.regularWhite16,
                                  ),
                                ),
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
