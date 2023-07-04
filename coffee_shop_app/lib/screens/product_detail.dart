import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/blocs/cart_cubit/cart_cubit.dart';
import '../services/blocs/product_detail/product_detail_bloc.dart';
import '../services/blocs/product_detail/product_detail_event.dart';
import '../services/blocs/product_detail/product_detail_state.dart'
    as product_detail_bloc;
import '../services/functions/money_transfer.dart';
import '../services/models/size.dart';
import '../services/models/topping.dart';
import '../utils/colors/app_colors.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../utils/styles/button.dart';
import '../widgets/feature/product_detail_widgets/circle_icon.dart';
import '../widgets/feature/product_detail_widgets/product_card.dart';
import '../widgets/feature/product_detail_widgets/product_detail_skeleton.dart';
import '../widgets/feature/product_detail_widgets/round_image.dart';
import '../widgets/feature/product_detail_widgets/square_amount_box.dart';
import '../widgets/global/custom_app_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final noteTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        BlocProvider.of<ProductDetailBloc>(context).add(DisposeProduct());
        return Future.value(false);
      },
      child: BlocBuilder<ProductDetailBloc,
          product_detail_bloc.ProductDetailState>(builder: (context, state) {
        if (state is product_detail_bloc.LoadedState) {
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ProductCard(product: state.selectedFood!),

                            Container(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              itemBuilder:
                                                  (context, index) => InkWell(
                                                        onTap: () {
                                                          BlocProvider.of<
                                                                      ProductDetailBloc>(
                                                                  context)
                                                              .add(SelectSize(
                                                                  selectedSize:
                                                                      state.productsSize[
                                                                          index]));
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Radio<Size>(
                                                                    value: state
                                                                            .productsSize[
                                                                        index],
                                                                    groupValue:
                                                                        state
                                                                            .selectedSize,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        if (value !=
                                                                            null) {
                                                                          BlocProvider.of<ProductDetailBloc>(context)
                                                                              .add(SelectSize(selectedSize: value));
                                                                        }
                                                                      });
                                                                    },
                                                                  ),
                                                                  RoundImage(
                                                                      imgUrl: state
                                                                          .productsSize[
                                                                              index]
                                                                          .image),
                                                                  SizedBox(
                                                                    width: Dimension
                                                                        .height8,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      state
                                                                          .productsSize[
                                                                              index]
                                                                          .name,
                                                                      style: AppText
                                                                          .style
                                                                          .regularBlack14,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              '+${MoneyTransfer.transferFromDouble(state.productsSize[index].price)} ₫',
                                                              style: AppText
                                                                  .style
                                                                  .boldBlack14,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              separatorBuilder: (_, __) =>
                                                  const Divider(
                                                    thickness: 2,
                                                    color:
                                                        AppColors.greyBoxColor,
                                                  ),
                                              itemCount:
                                                  state.productsSize.length),
                                        ]),
                                  ),

                            //topping
                            state.productsTopping.isNotEmpty
                                ? Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Topping",
                                              style: AppText.style.boldBlack16,
                                            ),
                                            Expanded(
                                              child: Text(
                                                ' (maximum 2)',
                                                style:
                                                    AppText.style.regularGrey14,
                                              ),
                                            )
                                          ],
                                        ),
                                        ListView.separated(
                                            padding: EdgeInsets.only(
                                                top: Dimension.height16),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            controller: ScrollController(),
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                ProductDetailBloc>(
                                                            context)
                                                        .add(SelectTopping(
                                                            index: index));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Checkbox(
                                                        value: state
                                                                .selectedToppings[
                                                            index],
                                                        onChanged: (value) {
                                                          if (value != null) {
                                                            BlocProvider.of<
                                                                        ProductDetailBloc>(
                                                                    context)
                                                                .add(SelectToppingWithValue(
                                                                    index:
                                                                        index,
                                                                    value:
                                                                        value));
                                                          }
                                                        },
                                                      ),
                                                      RoundImage(
                                                          imgUrl: state
                                                              .productsTopping[
                                                                  index]
                                                              .image),
                                                      SizedBox(
                                                        width:
                                                            Dimension.height8,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          state
                                                              .productsTopping[
                                                                  index]
                                                              .name,
                                                          style: AppText.style
                                                              .regularBlack14,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                      Text(
                                                        '+${MoneyTransfer.transferFromDouble(state.productsTopping[index].price)} ₫',
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
                                                state.productsTopping.length),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),

                            SizedBox(height: Dimension.height4),
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
                                      hintText: 'Ghi chú cho món ăn',
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
                                            isEnable: state.numberToAdd > 0,
                                            icon: CupertinoIcons.minus,
                                            backgroundColor: Colors.transparent,
                                            onTap: () {
                                              BlocProvider.of<
                                                          ProductDetailBloc>(
                                                      context)
                                                  .add(DecreaseAmount());
                                            }),
                                        SizedBox(
                                          width: Dimension.height8 / 2,
                                        ),
                                        SquareAmountBox(
                                            child: Text(
                                          state.numberToAdd.toString(),
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
                                              BlocProvider.of<
                                                          ProductDetailBloc>(
                                                      context)
                                                  .add(IncreaseAmount());
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
                                            i < state.selectedToppings.length;
                                            i++) {
                                          if (state.selectedToppings[i]) {
                                            toppingPrice +=
                                                state.productsTopping[i].price;
                                            toppingList
                                                .add(state.productsTopping[i]);
                                          }
                                        }
                                        String toppingString = toppingList
                                            .map((e) => e.id)
                                            .toList()
                                            .join(", ");

                                        double finalTotal =
                                            (state.totalPrice + toppingPrice) *
                                                state.numberToAdd;
                                        return ElevatedButton(
                                            style: roundedButton,
                                            onPressed: state.numberToAdd == 0
                                                ? null
                                                : () {
                                                    BlocProvider.of<CartCubit>(
                                                            context)
                                                        .addProduct(
                                                      state.selectedFood!,
                                                      state.numberToAdd,
                                                      state.selectedSize.id,
                                                      toppingString,
                                                      state.totalPrice +
                                                          toppingPrice,
                                                      noteTextController.text,
                                                    );
                                                    Navigator.of(context)
                                                        .maybePop();
                                                  },
                                            child: Text(
                                              'Thêm vào giỏ - ${MoneyTransfer.transferFromDouble(finalTotal)} ₫',
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
        } else {
          return ProductDetailSkeleton();
        }
      }),
    );
  }
}
