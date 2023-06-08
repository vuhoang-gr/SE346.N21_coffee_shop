import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/screens/store_address/map_screen.dart';
import 'package:coffee_shop_admin/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/edit_address/edit_address_event.dart';
import 'package:coffee_shop_admin/services/blocs/edit_address/edit_address_state.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_admin/services/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/models/address.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/global/custom_app_bar.dart';

MLocation _mLocation = MLocation(formattedAddress: "HCM", lat: 10.871759281171983, lng: 106.80328866625126);

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address_screen";
  final Address? deliveryAddress;
  const AddressScreen({super.key, required this.deliveryAddress});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> with InputValidationMixin {
  bool _isCreatingNewAddress = true;

  bool _isKeyboardOpened = false;

  late TextEditingController _addressController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    if (widget.deliveryAddress != null) {
      _isCreatingNewAddress = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      EditAddressBloc editAddressBloc = BlocProvider.of<EditAddressBloc>(context);
      editAddressBloc.add(InitForm(deliveryAddress: widget.deliveryAddress));
    });

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

  final _roundedOutlineButtonStyle = ButtonStyle(
      elevation: const MaterialStatePropertyAll(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.blueColor, width: 1),
        borderRadius: BorderRadius.circular(Dimension.height20),
      )),
      backgroundColor: const MaterialStatePropertyAll(Colors.white));

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogButton = IconButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    content: Builder(builder: (context) {
                      return SizedBox(
                        height: Dimension.height160,
                        width: Dimension.width296,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: Dimension.height43,
                              padding: EdgeInsets.symmetric(horizontal: Dimension.width16),
                              child: Text(
                                "Confirm",
                                textAlign: TextAlign.center,
                                style: AppText.style.boldBlack18,
                              ),
                            ),
                            SizedBox(
                              height: Dimension.height8,
                            ),
                            Container(
                                height: Dimension.height37,
                                alignment: Alignment.center,
                                child: Text(
                                  "Do you want to remove this address?",
                                  style: AppText.style.regular,
                                )),
                            SizedBox(
                              height: Dimension.height8,
                            ),
                            Container(
                                height: Dimension.height56,
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dimension.width16, vertical: Dimension.height8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          style: _roundedOutlineButtonStyle,
                                          child: Text(
                                            "Yes",
                                            style: AppText.style.regularBlue16,
                                          )),
                                    ),
                                    SizedBox(
                                      width: Dimension.width8,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: _roundedButtonStyle,
                                          child: Text(
                                            "No",
                                            style: AppText.style.regularWhite16,
                                          )),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      );
                    }));
              });
        },
        icon: const Icon(Icons.delete_outline));

    _isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 0;
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomAppBar(
                  leading: Text(
                    _isCreatingNewAddress ? "New address" : "Edit address",
                    style: AppText.style.boldBlack18,
                  ),
                  trailing: !_isCreatingNewAddress ? dialogButton : const SizedBox(),
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
                                            MLocation mLocation = location as MLocation;
                                            _mLocation = mLocation;
                                            _addressController.text = mLocation.formattedAddress;
                                            BlocProvider.of<EditAddressBloc>(context)
                                                .add(AddressChanged(address: mLocation));
                                          });
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed(MapScreen.routeName,
                                                  arguments: LatLng(10.871759281171983, 106.80328866625126))
                                              .then((location) {
                                            _mLocation = (location as MLocation);
                                            _addressController.text = (location as MLocation).formattedAddress;
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
                                        _submitForm(state);
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
                                    onPressed: () => _submitForm(state),
                                    style: _roundedButtonStyle,
                                    child: Text(
                                      "Add",
                                      style: AppText.style.regularWhite16,
                                    ));
                              }))
                    ],
                  ),
                ),
              ],
            )));
  }

  void _submitForm(EditAddressState editAddressState) async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection("Store").add({
        "address": {"formattedAddress": _mLocation.formattedAddress, "lat": _mLocation.lat, "lng": _mLocation.lng},
        "images": ["https://lh5.googleusercontent.com/p/AF1QipNIXjtOoJOOUiV7gx3oXW0Kcesi_GWmoy20gZz_=w408-h306-k-no"],
        "phone": editAddressState.phone,
        "shortName": editAddressState.nameReceiver,
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      BlocProvider.of<StoreStoreBloc>(context).add(FetchData());
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
