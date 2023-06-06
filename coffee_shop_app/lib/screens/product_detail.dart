import 'package:coffee_shop_app/services/apis/size_api.dart';
import 'package:coffee_shop_app/services/apis/topping_api.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_cubit/cart_cubit.dart';
import 'package:coffee_shop_app/services/models/store.dart';
import 'package:coffee_shop_app/services/models/topping.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/widgets/feature/product_detail_widgets/product_detail_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/functions/money_transfer.dart';
import '../services/models/food.dart';
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
  final Food product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var _selectedToppings = [];
  var _selectedSize;
  int _numberToAdd = 1;
  double _totalPrice = 0;
  bool isEnable = true;

  bool isLoading = false;

  final noteTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    noteTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchSizeAndTopping();
  }

  Future fetchSizeAndTopping() async {
    setState(() {
      isLoading = true;
    });
    try {
      Store? store = context.read<CartButtonBloc>().state.selectedStore;
      if (widget.product.sizes.isNotEmpty && widget.product.sizes[0] is! Size) {
        widget.product.sizes = await SizeApi().changeRefToObject(
            widget.product.sizes, store?.stateFood[widget.product.id]);
      }
      if (widget.product.toppings.isNotEmpty &&
          widget.product.toppings[0] is! Topping) {
        widget.product.toppings = await ToppingApi()
            .changeRefToObject(widget.product.toppings, store?.stateTopping);
      }
      _selectedSize = widget.product.sizes![0];

      _selectedToppings = List<bool>.generate(
          widget.product.toppings!.length, (index) => false);

      _totalPrice = widget.product.price + widget.product.sizes[0].price;

      //number to add
      _numberToAdd = 1;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra, hãy thử lại sau",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return isLoading
        ? ProductDetailSkeleton()
        : GestureDetector(
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        controller: ScrollController(),
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  double prevSizePrice =
                                                      (_selectedSize as Size)
                                                          .price;
                                                  _selectedSize = widget
                                                      .product.sizes![index];
                                                  _totalPrice = _totalPrice -
                                                      prevSizePrice +
                                                      widget.product
                                                          .sizes![index].price;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio<Size>(
                                                        value: widget.product
                                                            .sizes![index],
                                                        groupValue:
                                                            _selectedSize,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            double
                                                                prevSizePrice =
                                                                (_selectedSize
                                                                        as Size)
                                                                    .price;
                                                            _selectedSize =
                                                                value;
                                                            _totalPrice =
                                                                _totalPrice -
                                                                    prevSizePrice +
                                                                    value!
                                                                        .price;
                                                          });
                                                        },
                                                      ),
                                                      RoundImage(
                                                          imgUrl: widget
                                                              .product
                                                              .sizes![index]
                                                              .image),
                                                      SizedBox(
                                                        width:
                                                            Dimension.height8,
                                                      ),
                                                      Text(
                                                        widget.product
                                                            .sizes![index].name,
                                                        style: AppText.style
                                                            .regularBlack14,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '+${MoneyTransfer.transferFromDouble(widget.product.sizes![index].price)} ₫',
                                                    style: AppText
                                                        .style.boldBlack14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                        separatorBuilder: (_, __) =>
                                            const Divider(
                                              thickness: 2,
                                              color: AppColors.greyBoxColor,
                                            ),
                                        itemCount:
                                            widget.product.sizes!.length),
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
                                      padding: EdgeInsets.only(
                                          top: Dimension.height16),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      value: _selectedToppings[
                                                          index],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _selectedToppings[
                                                              index] = value;
                                                        });
                                                      },
                                                    ),
                                                    RoundImage(
                                                        imgUrl: widget
                                                            .product
                                                            .toppings![index]
                                                            .image),
                                                    SizedBox(
                                                      width: Dimension.height8,
                                                    ),
                                                    Text(
                                                        widget
                                                            .product
                                                            .toppings![index]
                                                            .name,
                                                        style: AppText.style
                                                            .regularBlack14),
                                                  ],
                                                ),
                                                Text(
                                                  '+${MoneyTransfer.transferFromDouble(widget.product.toppings![index].price)} ₫',
                                                  style:
                                                      AppText.style.boldBlack14,
                                                ),
                                              ],
                                            ),
                                          ),
                                      separatorBuilder: (_, __) =>
                                          const Divider(
                                            thickness: 2,
                                            color: AppColors.greyBoxColor,
                                          ),
                                      itemCount:
                                          widget.product.toppings!.length),
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
                                  controller: noteTextController,
                                  scrollPadding: EdgeInsets.only(
                                      bottom: Dimension.height16),
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
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: AppColors.greyTextColor)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          style: AppText.style.regularBlack16,
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
                                                if (_numberToAdd > 0 &&
                                                    !isEnable) {
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
                                      child: Builder(builder: (context) {
                                        double toppingPrice = 0;
                                        List<Topping> toppingList = [];

                                        for (var i = 0;
                                            i < _selectedToppings.length;
                                            i++) {
                                          if (_selectedToppings[i]) {
                                            toppingPrice += widget
                                                .product.toppings![i].price;
                                            toppingList.add(
                                                widget.product.toppings![i]);
                                          }
                                        }
                                        String toppingString = toppingList
                                            .map((e) => e.name)
                                            .toList()
                                            .join(", ");

                                        double finalTotal =
                                            (_totalPrice + toppingPrice) *
                                                _numberToAdd;
                                        return ElevatedButton(
                                            style: roundedButton,
                                            onPressed: _numberToAdd == 0
                                                ? null
                                                : () {
                                                    BlocProvider.of<CartCubit>(
                                                            context)
                                                        .addProduct(
                                                      widget.product,
                                                      _numberToAdd,
                                                      (_selectedSize as Size)
                                                          .id,
                                                      toppingString,
                                                      _totalPrice +
                                                          toppingPrice,
                                                      noteTextController.text,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                            child: Text(
                                              'Add to cart - ${MoneyTransfer.transferFromDouble(finalTotal)} ₫',
                                              style:
                                                  AppText.style.regularWhite16,
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
