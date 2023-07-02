import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/widgets/feature/store/store_address/map_screen.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/edit_address/edit_address_event.dart';
import 'package:coffee_shop_admin/services/blocs/edit_address/edit_address_state.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_admin/services/models/address.dart';
import 'package:coffee_shop_admin/services/models/location.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:quickalert/quickalert.dart';

MLocation _mLocation = MLocation(formattedAddress: "HCM", lat: 10.871759281171983, lng: 106.80328866625126);

class CreateStoreScreen extends StatefulWidget {
  static const String routeName = "/create_store";
  final Address? deliveryAddress;
  const CreateStoreScreen({super.key, required this.deliveryAddress});

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> with InputValidationMixin {
  bool _isKeyboardOpened = false;

  late TextEditingController _addressController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  TextEditingController openTimeController = TextEditingController();
  TextEditingController closeTimeController = TextEditingController();

  final imgController = MultiImagePickerController(
      maxImages: 6,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
      withData: false,
      withReadStream: false,
      images: <ImageFile>[]);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EditAddressBloc editAddressBloc = BlocProvider.of<EditAddressBloc>(context);
      editAddressBloc.add(InitForm(deliveryAddress: widget.deliveryAddress));
    });

    openTimeController.text = "08:00";
    closeTimeController.text = "22:00";

    String initAddress;
    if (widget.deliveryAddress == null) {
      initAddress = "";
    } else {
      initAddress = widget.deliveryAddress!.address.formattedAddress;
    }
    _addressController = TextEditingController(text: initAddress);

    super.initState();
  }

  generateTextDecoration({String hintString = ""}) {
    return InputDecoration(
      counterText: "",
      contentPadding: EdgeInsets.symmetric(horizontal: Dimension.width16, vertical: Dimension.height8),
      hintText: hintString,
      hintStyle: AppText.style.regularGrey14,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: AppColors.blackColor)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: AppColors.greyTextField)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: AppColors.redColor)),
      errorStyle: AppText.style.regularBlack14.copyWith(color: AppColors.redColor),
    );
  }

  generateDisableTextDecoration({String hintString = ""}) {
    return InputDecoration(
      counterText: "",
      contentPadding: EdgeInsets.symmetric(horizontal: Dimension.width16, vertical: Dimension.height8),
      hintText: hintString,
      fillColor: AppColors.greyBoxColor,
      filled: true,
      hintStyle: AppText.style.regularGrey14,
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: AppColors.greyTextField)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: AppColors.greyTextField)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: AppColors.redColor)),
      errorStyle: AppText.style.regularBlack14.copyWith(color: AppColors.redColor),
    );
  }

  final _roundedButtonStyle = ButtonStyle(
      elevation: const MaterialStatePropertyAll(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimension.height20),
      )),
      backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor));

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _addressController.dispose();
    super.dispose();
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
                    "Create store",
                    style: AppText.style.boldBlack18,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: Dimension.height16, horizontal: Dimension.width16),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
                            padding: EdgeInsets.symmetric(vertical: Dimension.height16, horizontal: Dimension.width16),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Address",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  BlocBuilder<EditAddressBloc, EditAddressState>(builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (state.address != null) {
                                          Navigator.of(context)
                                              .pushNamed(MapScreen.routeName,
                                                  arguments: LatLng(state.address!.lat, state.address!.lng))
                                              .then((location) {
                                            if (location != null) {
                                              MLocation mLocation = location as MLocation;
                                              _mLocation = mLocation;
                                              _addressController.text = mLocation.formattedAddress;
                                              BlocProvider.of<EditAddressBloc>(context)
                                                  .add(AddressChanged(address: mLocation));
                                            }
                                          });
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed(MapScreen.routeName,
                                                  arguments: LatLng(10.871759281171983, 106.80328866625126))
                                              .then((location) {
                                            if (location != null) {
                                              _mLocation = (location as MLocation);
                                              _addressController.text = (location).formattedAddress;
                                            }
                                          });
                                        }
                                      },
                                      child: TextFormField(
                                        controller: _addressController,
                                        enabled: false,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.name,
                                        style: AppText.style.regularBlack14,
                                        validator: (value) {
                                          if (!isAddressValid(value ?? "")) {
                                            return 'Please choose your address.';
                                          }
                                          return null;
                                        },
                                        decoration: generateDisableTextDecoration(hintString: "Select your address"),
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Store name",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  BlocBuilder<EditAddressBloc, EditAddressState>(builder: (context, state) {
                                    return TextFormField(
                                      initialValue: widget.deliveryAddress?.nameReceiver ?? "",
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name,
                                      style: AppText.style.regularBlack14,
                                      decoration: generateTextDecoration(hintString: "E.g The Coffee House Hoang Dieu"),
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context).requestFocus(_nameFocusNode);
                                      },
                                      validator: (value) {
                                        if (!isNameValid(value ?? "")) {
                                          return 'Please input the name.';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        BlocProvider.of<EditAddressBloc>(context)
                                            .add(NameReceiverChanged(nameReceiver: value));
                                      },
                                    );
                                  }),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Phone number",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  BlocBuilder<EditAddressBloc, EditAddressState>(builder: (context, state) {
                                    return TextFormField(
                                      initialValue: widget.deliveryAddress?.phone ?? "",
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.phone,
                                      focusNode: _phoneNumberFocusNode,
                                      style: AppText.style.regularBlack14,
                                      decoration: generateTextDecoration(hintString: "10-digit phone number"),
                                      onFieldSubmitted: (_) {
                                        _submitForm(state, false);
                                      },
                                      maxLength: 10,
                                      validator: (value) {
                                        if (!isPhoneValid(value ?? "")) {
                                          return 'Please input correct phone number.';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        BlocProvider.of<EditAddressBloc>(context).add(PhoneChanged(phone: value));
                                      },
                                    );
                                  }),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Time",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  Column(
                                    children: [
                                      DateTimePicker(
                                        type: DateTimePickerType.time,
                                        controller: openTimeController,
                                        icon: Icon(Icons.event),
                                        timeLabelText: "Open Time",
                                      ),
                                      DateTimePicker(
                                        type: DateTimePickerType.time,
                                        controller: closeTimeController,
                                        icon: Icon(Icons.event),
                                        timeLabelText: "Close Time",
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Images",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  //images
                                  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MultiImagePickerView(
                                          draggable: false,
                                          controller: imgController,
                                          padding: const EdgeInsets.all(10),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      _isKeyboardOpened
                          ? const SizedBox()
                          : Container(
                              height: Dimension.height56,
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: Dimension.width16, vertical: Dimension.height8),
                              child: BlocBuilder<EditAddressBloc, EditAddressState>(builder: (context, state) {
                                return ElevatedButton(
                                    onPressed: () => _submitForm(state, true),
                                    style: _roundedButtonStyle,
                                    child: Text(
                                      "Create",
                                      style: AppText.style.regularWhite16,
                                    ));
                              }))
                    ],
                  ),
                ),
              ],
            )));
  }

  void _submitForm(EditAddressState editAddressState, bool submit) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!submit) return;

      final imagePaths = imgController.images;
      if (imagePaths.isEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          confirmBtnText: "Ok",
          text: 'Please choose store images!',
        );
        return;
      }

      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Creating your new store...',
      );

      try {
        final storageRef = FirebaseStorage.instance.ref();
        List<String> imgUrlList = [];
        for (final image in imagePaths) {
          File img = image.hasPath ? File(image.path!) : File.fromRawPath(image.bytes!);
          final imgRef = storageRef.child("/stores/${img.path.split('/').last}${DateTime.now()}");
          await imgRef.putFile(img);
          await imgRef.getDownloadURL().then((url) {
            imgUrlList.add(url);
          });
        }

        DateTime openTime = DateTime.parse('2023-06-14 ${openTimeController.text}');
        DateTime closeTime = DateTime.parse('2023-06-14 ${closeTimeController.text}');
        await storeReference.add({
          "address": {"formattedAddress": _mLocation.formattedAddress, "lat": _mLocation.lat, "lng": _mLocation.lng},
          "images": imgUrlList,
          "phone": editAddressState.phone,
          "shortName": editAddressState.nameReceiver,
          "timeOpen": openTime,
          "timeClose": closeTime,
        }).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          BlocProvider.of<StoreStoreBloc>(context).add(FetchData());
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
          text: 'Something\'s wrong when create new store!',
          confirmBtnText: "Ok",
        );
        print("Something's wrong when create new store!");
        print(e);
      }
    }
  }
}

mixin InputValidationMixin {
  bool isAddressValid(String address) => address.isNotEmpty;
  bool isNameValid(String name) => name.isNotEmpty;

  bool isPhoneValid(String phone) {
    RegExp regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    return regex.hasMatch(phone);
  }
}
