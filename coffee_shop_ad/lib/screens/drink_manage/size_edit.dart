import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_event.dart';
import 'package:coffee_shop_admin/services/models/size.dart';
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

class EditSizeScreen extends StatefulWidget {
  static const routeName = "/edit_size";
  final Size product;
  const EditSizeScreen({super.key, required this.product});
  @override
  State<EditSizeScreen> createState() => _EditSizeScreenState();
}

class _EditSizeScreenState extends State<EditSizeScreen> {
  TextEditingController sizeNameController = TextEditingController();
  TextEditingController sizePriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sizeNameController.text = widget.product.name;
    sizePriceController.text = (widget.product.price.toInt()).toString();
  }

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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  bool _isValidData() {
    if (sizePriceController.text.isNotEmpty &&
        int.tryParse(sizePriceController.text) == null) return false;
    return true;
  }

  void _hanldeEditSize() async {
    if (!_isValidData()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        confirmBtnText: "Ok",
        text: 'Invalid data!',
      );
      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Editing your new Size...',
    );

    try {
      // update firestore
      sizeReference.doc(widget.product.id).update({
        "image": image != null ? "" : widget.product.image,
        "name": sizeNameController.text.isNotEmpty
            ? sizeNameController.text
            : widget.product.name,
        "price": sizePriceController.text.isNotEmpty
            ? int.parse(sizePriceController.text)
            : widget.product.price,
      }).then((value) async {
        if (image != null) {
          // remove old image
          FirebaseStorage.instance.refFromURL(widget.product.image).delete();

          // upload new img
          final storageRef = FirebaseStorage.instance.ref();
          final sizeImagesRef = storageRef
              .child('products/Size/Size${DateTime.now().toString()}');

          await sizeImagesRef.putFile(File(image!.path)).then((res) {
            res.ref.getDownloadURL().then((url) {
              sizeReference.doc(widget.product.id).update({
                "image": url,
              });
            });
          });
        }
      }).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        BlocProvider.of<SizeListBloc>(context).add(FetchData());
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Completed Successfully!',
          confirmBtnText: "Ok",
        );
      });
    } catch (e) {
      print("Something wrong when edit new Size");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomAppBar(
                  leading: Text(
                    "Edit Size",
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
                              margin: EdgeInsets.only(
                                  left: Dimension.height16,
                                  right: Dimension.height16,
                                  top: 3),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              File(image!.path),
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 300,
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              alignment: Alignment.center,
                                              width: double.maxFinite,
                                              imageUrl: widget.product.image,
                                              placeholder: (context, url) =>
                                                  Container(
                                                alignment: Alignment.center,
                                                child:
                                                    const CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(),
                                            ),
                                          ),
                                        ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        elevation:
                                            const MaterialStatePropertyAll(0),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimension.height20),
                                        )),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                AppColors.blueColor)),
                                    onPressed: () {
                                      uploadImageDialog();
                                    },
                                    child: Text("Choose another Photo"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimension.height16,
                                        right: Dimension.height16,
                                        top: Dimension.height12,
                                        bottom: Dimension.height16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            CustormTextForm(
                                              controller: sizeNameController,
                                              validator: NullValidator(),
                                              verifiedCheck: true,
                                              label: 'New name',
                                            ),
                                            SizedBox(height: 8),
                                            CustormTextForm(
                                              controller: sizePriceController,
                                              validator: PriceValidator(),
                                              verifiedCheck: true,
                                              label: 'New price (VND)',
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimension.width16,
                                  vertical: Dimension.height8),
                              child: ElevatedButton(
                                  onPressed: _hanldeEditSize,
                                  style: ButtonStyle(
                                      elevation:
                                          const MaterialStatePropertyAll(0),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimension.height20),
                                      )),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              AppColors.blueColor)),
                                  child: Text(
                                    "Edit Size",
                                    style: AppText.style.regularWhite16,
                                  )))
                    ],
                  ),
                ),
              ],
            )));
  }
}
