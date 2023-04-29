import 'package:coffee_shop_app/services/blocs/address_store/address_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_event.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_state.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_event.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/models/address.dart';
import '../services/models/delivery_address.dart';
import '../utils/colors/app_colors.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../widgets/global/custom_app_bar.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address_screen";
  final DeliveryAddress? deliveryAddress;
  final int index;
  const AddressScreen(
      {super.key, required this.deliveryAddress, this.index = -1});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen>
    with InputValidationMixin {
  bool _isCreatingNewAddress = true;

  bool _isKeyboardOpened = false;

  final _nameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EditAddressBloc editAddressBloc =
          BlocProvider.of<EditAddressBloc>(context);
      editAddressBloc.add(InitForm(deliveryAddress: widget.deliveryAddress));
      if (widget.deliveryAddress != null) {
        _isCreatingNewAddress = false;
      }
    });
  }

  generateTextDecoration({String hintString = ""}) {
    return InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            horizontal: Dimension.width16, vertical: Dimension.height8),
        hintText: hintString,
        hintStyle: AppText.style.regularGrey14,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.blackColor)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.greyTextField)));
  }

  final _roundedButtonStyle = ButtonStyle(
      elevation: const MaterialStatePropertyAll(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimension.height20),
      )),
      backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor));

  final _roundedOutlineButtonStyle = ButtonStyle(
      elevation: const MaterialStatePropertyAll(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.blueColor, width: 1),
        borderRadius: BorderRadius.circular(Dimension.height20),
      )),
      backgroundColor: const MaterialStatePropertyAll(Colors.white));

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimension.width16),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimension.width16,
                                    vertical: Dimension.height8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            //TODO: need to handle it
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
                  trailing:
                      !_isCreatingNewAddress ? dialogButton : const SizedBox(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Dimension.height16,
                                horizontal: Dimension.width16),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.white),
                            padding: EdgeInsets.symmetric(
                                vertical: Dimension.height16,
                                horizontal: Dimension.width16),
                            child: Form(
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
                                  BlocBuilder<EditAddressBloc,
                                          EditAddressState>(
                                      builder: (context, state) {
                                    return TextFormField(
                                      initialValue: widget.deliveryAddress
                                              ?.address.shortName ??
                                          "",
                                      style: AppText.style.regularBlack14,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      decoration: generateTextDecoration(
                                          hintString:
                                              "Lot number, street number"),
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_nameFocusNode);
                                      },
                                      validator: (value) {
                                        if (isSubAddressValid(value ?? "")) {
                                          return 'Please provide a value';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        BlocProvider.of<EditAddressBloc>(
                                                context)
                                            .add(SubAddressChanged(
                                                subAddress: value));
                                      },
                                    );
                                  }),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "City",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  DropdownButtonFormField(
                                      hint: Text(
                                        "Select city",
                                        style: AppText.style.regularGrey14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      decoration: generateTextDecoration(
                                          hintString: "Select city"),
                                      icon: const FaIcon(
                                        FontAwesomeIcons.chevronDown,
                                        color: AppColors.greyTextColor,
                                      ),
                                      focusColor: Colors.black,
                                      items: const [],
                                      onChanged: (_) {}),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "District",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  DropdownButtonFormField(
                                      hint: Text(
                                        "Select district",
                                        style: AppText.style.regularGrey14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      decoration: generateTextDecoration(
                                          hintString: "Select city"),
                                      icon: const FaIcon(
                                        FontAwesomeIcons.chevronDown,
                                        color: AppColors.greyTextColor,
                                      ),
                                      focusColor: Colors.black,
                                      items: const [],
                                      onChanged: (_) {}),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Ward",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  DropdownButtonFormField(
                                      hint: Text(
                                        "Select ward",
                                        style: AppText.style.regularGrey14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      decoration: generateTextDecoration(
                                          hintString: "Select city"),
                                      icon: const FaIcon(
                                        FontAwesomeIcons.chevronDown,
                                        color: AppColors.greyTextColor,
                                      ),
                                      focusColor: Colors.black,
                                      items: const [],
                                      onChanged: (_) {}),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Recipient's name",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  BlocBuilder<EditAddressBloc,
                                          EditAddressState>(
                                      builder: (context, state) {
                                    return TextFormField(
                                      initialValue: widget
                                              .deliveryAddress?.nameReceiver ??
                                          "",
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name,
                                      focusNode: _nameFocusNode,
                                      style: AppText.style.regularBlack14,
                                      decoration: generateTextDecoration(
                                          hintString: "E.g Nguyen Van A"),
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_nameFocusNode);
                                      },
                                      validator: (value) {
                                        if (isNameValid(value ?? "")) {
                                          return 'Please provide a value.';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        BlocProvider.of<EditAddressBloc>(
                                                context)
                                            .add(NameReceiverChanged(
                                                nameReceiver: value));
                                      },
                                    );
                                  }),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Recipient's phone number",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  BlocBuilder<EditAddressBloc,
                                          EditAddressState>(
                                      builder: (context, state) {
                                    return TextFormField(
                                      initialValue:
                                          widget.deliveryAddress?.phone ?? "",
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.phone,
                                      focusNode: _phoneNumberFocusNode,
                                      style: AppText.style.regularBlack14,
                                      decoration: generateTextDecoration(
                                          hintString: "11-digit phone number"),
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_nameFocusNode);
                                      },
                                      maxLength: 11,
                                      validator: (value) {
                                        if (isPhoneValid(value ?? "")) {
                                          return 'Please provide correct phone number.';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        BlocProvider.of<EditAddressBloc>(
                                                context)
                                            .add(PhoneChanged(phone: value));
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimension.width16,
                                  vertical: Dimension.height8),
                              child: BlocBuilder<EditAddressBloc,
                                      EditAddressState>(
                                  builder: (context, editAddressState) {
                                return BlocBuilder<AddressStoreBloc,
                                        AddressStoreState>(
                                    builder: (context, addressStoreState) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        if (addressStoreState is LoadedState) {
                                          DeliveryAddress deliveryAddress =
                                              DeliveryAddress(
                                                  address: Address(
                                                      city: "",
                                                      district: "",
                                                      ward: "",
                                                      shortName:
                                                          editAddressState
                                                              .subAddress),
                                                  nameReceiver: editAddressState
                                                      .nameReceiver,
                                                  phone:
                                                      editAddressState.phone);
                                          if (widget.index == -1) {
                                            addressStoreState
                                                .listDeliveryAddress
                                                .add(deliveryAddress);
                                          } else {
                                            addressStoreState
                                                    .listDeliveryAddress[
                                                widget.index] = deliveryAddress;
                                          }

                                          BlocProvider.of<AddressStoreBloc>(
                                                  context)
                                              .add(ListAddressUpdated(
                                                  listDeliveryAddress:
                                                      addressStoreState
                                                          .listDeliveryAddress));
                                        }
                                      },
                                      style: _roundedButtonStyle,
                                      child: Text(
                                        "Save",
                                        style: AppText.style.regularWhite16,
                                      ));
                                });
                              }))
                    ],
                  ),
                ),
              ],
            )));
  }
}

mixin InputValidationMixin {
  bool isSubAddressValid(String subAddress) => subAddress.isNotEmpty;
  bool isNameValid(String name) => name.isNotEmpty;

  bool isPhoneValid(String phone) {
    RegExp regex = RegExp(
        r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$');
    return regex.hasMatch(phone);
  }
}
