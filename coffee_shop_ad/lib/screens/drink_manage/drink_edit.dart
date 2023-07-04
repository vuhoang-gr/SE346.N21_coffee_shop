import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/validations/validator.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:coffee_shop_admin/widgets/global/textForm/custom_text_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:quickalert/quickalert.dart';

class EditDrinkScreen extends StatefulWidget {
  static const routeName = "/edit_drink";
  final Drink product;
  const EditDrinkScreen({super.key, required this.product});
  @override
  State<EditDrinkScreen> createState() => _EditDrinkScreenState();
}

class _EditDrinkScreenState extends State<EditDrinkScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<dynamic> _imageUrls = [];

  @override
  void initState() {
    nameController.text = widget.product.name;
    priceController.text = widget.product.price.toInt().toString();
    descriptionController.text = widget.product.description;
    _imageUrls = widget.product.images;
    super.initState();
  }

  final imgController = MultiImagePickerController(
      maxImages: 6,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
      withData: false,
      withReadStream: false,
      images: <ImageFile>[]);

  bool _isKeyboardOpened = false;

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 0;
    // ignore: no_leading_underscores_for_local_identifiers
    bool _validateData() {
      final images = imgController.images;
      if (images.isEmpty && _imageUrls.isEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          confirmBtnText: "Ok",
          confirmBtnColor: AppColors.blueColor,
          confirmBtnTextStyle: AppText.style.regularWhite16,
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
          confirmBtnColor: AppColors.blueColor,
          confirmBtnTextStyle: AppText.style.regularWhite16,
          text: 'Invalid Data',
        );
        return false;
      }
      return true;
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _hanldeEditDrink() async {
      if (!_validateData()) {
        print("Invalid data!");
        return;
      }
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Saving your drink...',
      );

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
        for (final img in widget.product.images) {
          if (_imageUrls.contains(img) == false) FirebaseStorage.instance.refFromURL(img).delete();
        }
        for (int i = 0; i < widget.product.images.length; i++) {
          var url = widget.product.images[i].toString();
          if (_imageUrls.contains(url)) imgUrlList.add(url);
        }
        drinkReference.doc(widget.product.id).update({
          "name": nameController.text,
          "price": int.parse(priceController.text),
          "description": descriptionController.text,
          "images": imgUrlList,
        }).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Completed Successfully!',
            confirmBtnText: "Ok",
            confirmBtnColor: AppColors.blueColor,
          );
        });
      } catch (e) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Something\'s wrong when edit drink!',
          confirmBtnText: "Ok",
          confirmBtnColor: AppColors.blueColor,
        );
        print("Something's wrong when edit drink");
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
                    "Edit Drink",
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
                                      "Drink Images",
                                      style: AppText.style.boldBlack16,
                                    ),
                                    SizedBox(height: 8),
                                    _imageUrls.isEmpty
                                        ? SizedBox()
                                        : CarouselSlider(
                                            options: CarouselOptions(
                                              enableInfiniteScroll: false,
                                              enlargeCenterPage: true,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                            items: _imageUrls.map((e) {
                                              // return CachedNetworkImage(imageUrl: e);
                                              return Stack(
                                                children: [
                                                  Card(
                                                    semanticContainer: true,
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    margin: EdgeInsets.all(10),
                                                    child: CachedNetworkImage(imageUrl: e),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        _imageUrls.remove(e);
                                                        Fluttertoast.showToast(
                                                            msg: "Image removed!",
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.CENTER,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.black,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0);
                                                        setState(() {});
                                                      },
                                                      child: Icon(
                                                        Icons.close_rounded,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                  ]),
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
                                      "Upload more images",
                                      style: AppText.style.boldBlack16,
                                    ),
                                    MultiImagePickerView(
                                      draggable: false,
                                      controller: imgController,
                                      padding: const EdgeInsets.all(10),
                                    ),
                                  ]),
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
                                  onPressed: _hanldeEditDrink,
                                  style: ButtonStyle(
                                      elevation: const MaterialStatePropertyAll(0),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimension.height20),
                                      )),
                                      backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor)),
                                  child: Text(
                                    "Save",
                                    style: AppText.style.regularWhite16,
                                  )))
                    ],
                  ),
                ),
              ],
            )));
  }
}
