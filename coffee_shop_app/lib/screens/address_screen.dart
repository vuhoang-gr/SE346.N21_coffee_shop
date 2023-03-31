import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/colors/app_colors.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../widgets/global/custom_app_bar.dart';

class AddressScreen extends StatefulWidget {
  static String routeName = "/address_screen";
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool? _isSavedToAddressBook = false;

  bool _isCreatingNewAddress = true;

  bool _isKeyboardOpened = false;

  final _nameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _editedInfo = {
    "address": "",
    "name": "",
    "phoneNumber": "",
  };

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

    //get data from previous page
    if (ModalRoute.of(context)!.settings.arguments != null) {
      _editedInfo = ModalRoute.of(context)!.settings.arguments as dynamic;
      _isCreatingNewAddress = false;
    }

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
                              key: _form,
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
                                  TextFormField(
                                    initialValue:
                                        _editedInfo["address"] as String,
                                    style: TextStyle(
                                        height: 1.5,
                                        fontSize: Dimension.font14),
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
                                      if (value == null || value.isEmpty) {
                                        return 'Please provide a value.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _editedInfo["address"] = value ?? "";
                                    },
                                  ),
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
                                  TextFormField(
                                    initialValue: _editedInfo["name"] as String,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.name,
                                    focusNode: _nameFocusNode,
                                    style: TextStyle(
                                        height: 1.5,
                                        fontSize: Dimension.font14),
                                    decoration: generateTextDecoration(
                                        hintString: "E.g Nguyen Van A"),
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_nameFocusNode);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please provide a value.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _editedInfo["name"] = value ?? "";
                                    },
                                  ),
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
                                  TextFormField(
                                    initialValue:
                                        _editedInfo["phoneNumber"] as String,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.phone,
                                    focusNode: _phoneNumberFocusNode,
                                    style: TextStyle(
                                        height: 1.5,
                                        fontSize: Dimension.font14),
                                    decoration: generateTextDecoration(
                                        hintString: "11-digit phone number"),
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_nameFocusNode);
                                    },
                                    maxLength: 11,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please provide a value.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _editedInfo["phoneNumber"] = value ?? "";
                                    },
                                  ),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Transform.translate(
                                    offset: Offset(-Dimension.width16, 0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isSavedToAddressBook =
                                              !_isSavedToAddressBook!;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: _isSavedToAddressBook,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _isSavedToAddressBook =
                                                    newValue;
                                              });
                                            },
                                            activeColor: AppColors.blueColor,
                                            checkColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4))),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Save to address book",
                                              style: AppText.style.regular,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
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
                              child: ElevatedButton(
                                  onPressed: () {}, //TODO:
                                  style: _roundedButtonStyle,
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
