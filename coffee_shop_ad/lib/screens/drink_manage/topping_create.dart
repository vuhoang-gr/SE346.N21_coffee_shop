import 'dart:io';

import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_event.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/validations/validator.dart';
import 'package:coffee_shop_admin/widgets/global/textForm/custom_text_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/global/custom_app_bar.dart';

class CreateToppingScreen extends StatefulWidget {
  static const routeName = "/create_topping";
  const CreateToppingScreen({super.key});
  @override
  State<CreateToppingScreen> createState() => _CreateToppingScreenState();
}

class _CreateToppingScreenState extends State<CreateToppingScreen> {
  TextEditingController toppingNameController = TextEditingController();
  TextEditingController toppingPriceController = TextEditingController();
  bool _isKeyboardOpened = false;

  String imageUrl = "";
  XFile? image;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void uploadImageDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 0;
    bool _validateData() {
      if (image == null ||
          toppingNameController.text.isEmpty ||
          toppingPriceController.text.isEmpty ||
          int.tryParse(toppingPriceController.text.toString()) == null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          confirmBtnText: "Ok",
          text: 'Please choose an image, input name and price!',
        );
        return false;
      }
      return true;
    }

    void _hanldeCreateTopping() async {
      if (!_validateData()) {
        print("Invalid data!");
        return;
      }
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Creating your new topping...',
      );

      final storageRef = FirebaseStorage.instance.ref();

      final toppingImagesRef = storageRef.child('products/topping/topping${DateTime.now().toString()}');

      try {
        await toppingImagesRef.putFile(File(image!.path)).then((res) {
          res.ref.getDownloadURL().then((url) {
            toppingReference.add({
              "image": url,
              "name": toppingNameController.text,
              "price": int.parse(toppingPriceController.text),
            });
          }).then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            BlocProvider.of<ToppingListBloc>(context).add(FetchData());
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Completed Successfully!',
              confirmBtnText: "Ok",
            );
          });
        });
      } catch (e) {
        print("Something wrong when create new topping");
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
                    "New Topping",
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
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.only(left: Dimension.height16, right: Dimension.height16, top: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 16),
                                  image != null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              File(image!.path),
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context).size.width,
                                              height: 300,
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Center(
                                                widthFactor: MediaQuery.of(context).size.width,
                                                child: Icon(IconData(0xee39, fontFamily: 'MaterialIcons'))),
                                          ),
                                        ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(0),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(Dimension.height20),
                                        )),
                                        backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor)),
                                    onPressed: () {
                                      uploadImageDialog();
                                    },
                                    child: Text(image != null ? "Rechoose Photo" : "Choose Photo"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimension.height16,
                                        right: Dimension.height16,
                                        top: Dimension.height12,
                                        bottom: Dimension.height16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Column(
                                        //       crossAxisAlignment:
                                        //           CrossAxisAlignment.start,
                                        //       children: [
                                        //         Text(
                                        //           "Name",
                                        //           style: AppText
                                        //               .style.regularBlack16,
                                        //         ),
                                        //         const SizedBox(
                                        //           height: 2,
                                        //         ),
                                        //         Text("Price",
                                        //             style: AppText
                                        //                 .style.boldBlack14),
                                        //       ],
                                        //     ),
                                        //   ],
                                        // ),
                                        Column(
                                          children: [
                                            CustormTextForm(
                                              controller: toppingNameController,
                                              validator: NullValidator(),
                                              verifiedCheck: true,
                                              label: 'Topping Name',
                                            ),
                                            SizedBox(height: 8),
                                            CustormTextForm(
                                              controller: toppingPriceController,
                                              validator: PriceValidator(),
                                              verifiedCheck: true,
                                              label: 'Price (VND)',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
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
                                  onPressed: _hanldeCreateTopping,
                                  style: ButtonStyle(
                                      elevation: const MaterialStatePropertyAll(0),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimension.height20),
                                      )),
                                      backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor)),
                                  child: Text(
                                    "Create Topping",
                                    style: AppText.style.regularWhite16,
                                  )))
                    ],
                  ),
                ),
              ],
            )));
  }
}
