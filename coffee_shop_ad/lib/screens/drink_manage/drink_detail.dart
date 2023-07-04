import 'package:coffee_shop_admin/screens/drink_manage/drink_edit.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/functions/money_transfer.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/styles/button.dart';
import 'package:coffee_shop_admin/widgets/feature/drink_detail_widgets/product_card.dart';
import 'package:coffee_shop_admin/widgets/feature/drink_detail_widgets/round_image.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class DrinkDetail extends StatefulWidget {
  final Drink product;
  const DrinkDetail({super.key, required this.product});

  @override
  State<DrinkDetail> createState() => _DrinkDetailState();
}

class _DrinkDetailState extends State<DrinkDetail> {
  var _selectedToppings = [];
  var _selectedSizes = [];

  @override
  void initState() {
    super.initState();

    _selectedSizes = widget.product.selectedSizes ?? List<bool>.generate(Drink.sizes.length, (index) => false);

    _selectedToppings = widget.product.selectedToppings ?? List<bool>.generate(Drink.toppings.length, (index) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    // ignore: no_leading_underscores_for_local_identifiers
    void _handleOnTapEditDrink() {
      Navigator.of(context).pushNamed(EditDrinkScreen.routeName, arguments: widget.product);
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _handleOnTapDeleteDrink() async {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: 'Do you want to delete ${widget.product.name}?',
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        confirmBtnColor: AppColors.blueColor,
        confirmBtnTextStyle: AppText.style.regularWhite16,
        cancelBtnTextStyle: AppText.style.regularBlue16,
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.loading,
            title: 'Loading',
            text: 'Deleting ${widget.product.name}',
          );
          List imgUrls = widget.product.images;

          try {
            await drinkReference.doc(widget.product.id).delete().then((value) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Completed Successfully!',
                confirmBtnText: "Ok",
                confirmBtnColor: AppColors.blueColor,
              );

              for (final img in imgUrls) {
                FirebaseStorage.instance.refFromURL(img).delete();
              }
            });
          } catch (e) {
            print("Something wrong when delete size");
            print(e);
          }
        },
      );
    }

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
                    leading: Text(
                      'Drink: ${widget.product.name}',
                      style: AppText.style.regularBlack16,
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    children: [
                      ProductCard(product: widget.product),

                      //size
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: Dimension.height16, vertical: Dimension.height16),
                        margin: EdgeInsets.only(
                            top: Dimension.height12, left: Dimension.height16, right: Dimension.height16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Size",
                              style: AppText.style.boldBlack16,
                            ),
                            ListView.separated(
                                padding: EdgeInsets.only(top: Dimension.height16),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                controller: ScrollController(),
                                itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedSizes[index] = !_selectedSizes[index];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: _selectedSizes[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedSizes[index] = value;
                                                    });
                                                  },
                                                ),
                                                RoundImage(imgUrl: Drink.sizes[index].image),
                                                SizedBox(
                                                  width: Dimension.height8,
                                                ),
                                                Expanded(
                                                    child: Text(Drink.sizes[index].name,
                                                        style: AppText.style.regularBlack14)),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '+${MoneyTransfer.transferFromDouble(Drink.sizes[index].price)} ₫',
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                    ),
                                separatorBuilder: (_, __) => const Divider(
                                      thickness: 2,
                                      color: AppColors.greyBoxColor,
                                    ),
                                itemCount: Drink.sizes.length),
                          ],
                        ),
                      ),

                      //topping
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: Dimension.height16, vertical: Dimension.height16),
                        margin: EdgeInsets.only(
                            top: Dimension.height12, left: Dimension.height16, right: Dimension.height16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Topping",
                              style: AppText.style.boldBlack16,
                            ),
                            ListView.separated(
                                padding: EdgeInsets.only(top: Dimension.height16),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                controller: ScrollController(),
                                itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedToppings[index] = !_selectedToppings[index];
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: _selectedToppings[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedToppings[index] = value;
                                                    });
                                                  },
                                                ),
                                                RoundImage(imgUrl: Drink.toppings[index].image),
                                                SizedBox(
                                                  width: Dimension.height8,
                                                ),
                                                Expanded(
                                                    child: Text(Drink.toppings[index].name,
                                                        style: AppText.style.regularBlack14)),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '+${MoneyTransfer.transferFromDouble(Drink.toppings[index].price)} ₫',
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                    ),
                                separatorBuilder: (_, __) => const Divider(
                                      thickness: 2,
                                      color: AppColors.greyBoxColor,
                                    ),
                                itemCount: Drink.toppings.length),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 44),
                          SizedBox(
                              height: Dimension.height40,
                              width: 140,
                              child: ElevatedButton.icon(
                                  style: roundedButton,
                                  onPressed: _handleOnTapEditDrink,
                                  icon: Icon(
                                    Icons.create_sharp,
                                    size: 28,
                                  ),
                                  label: Text(
                                    'Edit',
                                    style: AppText.style.regularWhite16,
                                  ))),
                          Spacer(),
                          SizedBox(
                            height: Dimension.height40,
                            width: 140,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(45)))),
                                icon: Icon(
                                  Icons.delete_forever,
                                  size: 28,
                                ),
                                onPressed: _handleOnTapDeleteDrink,
                                label: Text(
                                  'Delete',
                                  style: AppText.style.regularWhite16,
                                )),
                          ),
                          SizedBox(width: 44),
                        ],
                      ),

                      SizedBox(height: 20)
                    ],
                  ))),

                  //add to cart bar
                  isKeyboard
                      ? const SizedBox()
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimension.height16, vertical: Dimension.height8),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height: Dimension.height40,
                                child: ElevatedButton(
                                    style: roundedButton,
                                    onPressed: () async {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.loading,
                                        title: 'Loading',
                                        text: 'Saving ${widget.product.name}...',
                                      );

                                      List<String> updatedSizes = [];
                                      for (int i = 0; i < Drink.sizes.length; i++) {
                                        if (_selectedSizes[i]) {
                                          updatedSizes.add(Drink.sizes[i].id);
                                        }
                                      }
                                      List<String> updatedToppings = [];
                                      for (int i = 0; i < Drink.toppings.length; i++) {
                                        if (_selectedToppings[i]) {
                                          updatedToppings.add(Drink.toppings[i].id);
                                        }
                                      }

                                      await drinkReference
                                          .doc(widget.product.id)
                                          .update({"sizes": updatedSizes, "toppings": updatedToppings}).then((value) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text: 'Completed Successfully!',
                                          confirmBtnText: "Ok",
                                          confirmBtnColor: AppColors.blueColor,
                                        );
                                      }).catchError((err) {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          text: 'Error when saving drink!',
                                          confirmBtnText: "Ok",
                                          confirmBtnColor: AppColors.blueColor,
                                        );
                                      });
                                    },
                                    child: Text(
                                      'Save',
                                      style: AppText.style.regularWhite16,
                                    )),
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
