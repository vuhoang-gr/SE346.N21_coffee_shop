import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/services/functions/money_transfer.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/validations/validator.dart';
import 'package:coffee_shop_admin/widgets/feature/drink_detail_widgets/round_image.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:coffee_shop_admin/widgets/global/textForm/custom_text_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:quickalert/quickalert.dart';

class CreateDrinkScreen extends StatefulWidget {
  static const routeName = "/create_drink";

  const CreateDrinkScreen({super.key});
  @override
  State<CreateDrinkScreen> createState() => _CreateDrinkScreenState();
}

class _CreateDrinkScreenState extends State<CreateDrinkScreen> {
  var _selectedToppings = [];
  var _selectedSizes = [];

  @override
  void initState() {
    super.initState();

    _selectedSizes = List<bool>.generate(Drink.sizes.length, (index) => false);
    _selectedToppings = List<bool>.generate(Drink.toppings.length, (index) => false);
  }

  final imgController = MultiImagePickerController(
      maxImages: 6,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
      withData: false,
      withReadStream: false,
      images: <ImageFile>[]);

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool _isKeyboardOpened = false;

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 0;
    // ignore: no_leading_underscores_for_local_identifiers
    bool _validateData() {
      final images = imgController.images;
      if (images.isEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          confirmBtnText: "Ok",
          text: 'Please choose drink images!',
        );
        return false;
      }

      if (nameController.text.isEmpty ||
          priceController.text.isEmpty ||
          int.tryParse(priceController.text.toString()) == null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          confirmBtnText: "Ok",
          text: 'Invalid Data',
        );
        return false;
      }
      return true;
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _hanldeCreateDrink() async {
      if (!_validateData()) {
        print("Invalid data!");
        return;
      }
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Creating your new drink...',
      );

      List<String> sizes = [];
      for (int i = 0; i < _selectedSizes.length; i++) {
        if (_selectedSizes[i] == true) {
          sizes.add(Drink.sizes[i].id);
        }
      }
      List<String> toppings = [];
      for (int i = 0; i < _selectedToppings.length; i++) {
        if (_selectedToppings[i] == true) {
          toppings.add(Drink.toppings[i].id);
        }
      }

      try {
        final imagePaths = imgController.images;
        final storageRef = FirebaseStorage.instance.ref();
        List<String> imgUrlList = [];
        for (final image in imagePaths) {
          File img = image.hasPath ? File(image.path!) : File.fromRawPath(image.bytes!);
          final imgRef = storageRef.child("products/food/${img.path.split('/').last}${DateTime.now()}");
          await imgRef.putFile(img);
          await imgRef.getDownloadURL().then((url) {
            imgUrlList.add(url);
          });
        }
        FirebaseFirestore.instance.collection("Food").add({
          "name": nameController.text,
          "price": int.parse(priceController.text),
          "description": descriptionController.text,
          "createAt": FieldValue.serverTimestamp(),
          "sizes": sizes,
          "toppings": toppings,
          "images": imgUrlList,
        }).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Completed Successfully!',
            confirmBtnText: "Ok",
          );
        });
      } catch (e) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Something\'s wrong when create new drink!',
          confirmBtnText: "Ok",
        );
        print("Something's wrong when create new drink");
        print(e);
      }
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomAppBar(
                  leading: Text(
                    "New Drink",
                    style: AppText.style.boldBlack18,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.only(left: Dimension.height16, right: Dimension.height16, top: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimension.height16,
                                        right: Dimension.height16,
                                        top: Dimension.height12,
                                        bottom: Dimension.height16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Information",
                                          style: AppText.style.boldBlack16,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(height: 16),
                                            CustormTextForm(
                                              controller: nameController,
                                              validator: NullValidator(),
                                              verifiedCheck: true,
                                              label: 'Drink Name',
                                            ),
                                            SizedBox(height: 12),
                                            CustormTextForm(
                                              controller: priceController,
                                              validator: PriceValidator(),
                                              verifiedCheck: true,
                                              label: 'Price (VND)',
                                            ),
                                            SizedBox(height: 12),
                                            Container(
                                                height: Dimension.height12 * 13,
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: TextField(
                                                  controller: descriptionController,
                                                  scrollPadding: EdgeInsets.only(bottom: Dimension.height16),
                                                  textAlignVertical: TextAlignVertical.top,
                                                  expands: true,
                                                  maxLength: 300,
                                                  style: AppText.style.regularBlack14,
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(
                                                          top: Dimension.height8,
                                                          left: Dimension.height16,
                                                          right: Dimension.height16),
                                                      hintText: 'Description',
                                                      hintStyle: AppText.style.regularGrey14,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: AppColors.greyTextColor)),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: AppColors.greyBoxColor))),
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: null,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //images
                            Container(
                              width: double.maxFinite,
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dimension.height16, vertical: Dimension.height16),
                              margin: EdgeInsets.only(
                                  top: Dimension.height12, left: Dimension.height16, right: Dimension.height16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Images",
                                      style: AppText.style.boldBlack16,
                                    ),
                                    MultiImagePickerView(
                                      draggable: false,
                                      controller: imgController,
                                      padding: const EdgeInsets.all(10),
                                    ),
                                  ]),
                            ),

                            //size
                            Container(
                              width: double.maxFinite,
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dimension.height16, vertical: Dimension.height16),
                              margin: EdgeInsets.only(
                                  top: Dimension.height12, left: Dimension.height16, right: Dimension.height16),
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
                                                  _selectedSizes[index] = !_selectedSizes[index];
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
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
                                                      Text(
                                                        Drink.sizes[index].name,
                                                        style: AppText.style.regularBlack14,
                                                      ),
                                                    ],
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
                                  ]),
                            ),

                            //topping
                            Container(
                              width: double.maxFinite,
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dimension.height16, vertical: Dimension.height16),
                              margin: EdgeInsets.only(
                                  top: Dimension.height12, left: Dimension.height16, right: Dimension.height16),
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
                                      ],
                                    ),
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
                                                      Text(Drink.toppings[index].name,
                                                          style: AppText.style.regularBlack14),
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
                            SizedBox(height: 20),
                          ],
                        ),
                      )),
                      _isKeyboardOpened
                          ? const SizedBox()
                          : Container(
                              height: Dimension.height56,
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: Dimension.width16, vertical: Dimension.height8),
                              child: ElevatedButton(
                                  onPressed: _hanldeCreateDrink,
                                  style: ButtonStyle(
                                      elevation: const MaterialStatePropertyAll(0),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimension.height20),
                                      )),
                                      backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor)),
                                  child: Text(
                                    "Create Drink",
                                    style: AppText.style.regularWhite16,
                                  )))
                    ],
                  ),
                ),
              ],
            )));
  }
}
