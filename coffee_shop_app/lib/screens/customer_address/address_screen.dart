import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/screens/customer_address/map_screen.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_bloc.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_event.dart';
import 'package:coffee_shop_app/services/blocs/edit_address/edit_address_state.dart';
import 'package:coffee_shop_app/services/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/models/delivery_address.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/global/custom_app_bar.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address_screen";
  final DeliveryAddress? deliveryAddress;
  const AddressScreen({super.key, required this.deliveryAddress});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen>
    with InputValidationMixin {
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

    EditAddressBloc editAddressBloc = BlocProvider.of<EditAddressBloc>(context);
    editAddressBloc.add(InitForm(deliveryAddress: widget.deliveryAddress));

    String initAddressString;
    if (widget.deliveryAddress == null) {
      initAddressString = "";
    } else {
      initAddressString = widget.deliveryAddress!.address.formattedAddress;
    }
    _addressController = TextEditingController(text: initAddressString);

    super.initState();
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
          borderSide: const BorderSide(color: AppColors.greyTextField)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.redColor)),
      errorStyle:
          AppText.style.regularBlack14.copyWith(color: AppColors.redColor),
    );
  }

  generateDisableTextDecoration({String hintString = ""}) {
    return InputDecoration(
      counterText: "",
      contentPadding: EdgeInsets.symmetric(
          horizontal: Dimension.width16, vertical: Dimension.height8),
      hintText: hintString,
      fillColor: AppColors.greyBoxColor,
      filled: true,
      hintStyle: AppText.style.regularGrey14,
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.greyTextField)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.greyTextField)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.redColor)),
      errorStyle:
          AppText.style.regularBlack14.copyWith(color: AppColors.redColor),
    );
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
                                "Thông báo",
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
                                  "Bạn có chắc muốn xóa địa chỉ này?",
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
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop(true);
                                          },
                                          style: _roundedOutlineButtonStyle,
                                          child: Text(
                                            "Có",
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
                                            "Không",
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
                    _isCreatingNewAddress
                        ? "Thêm địa chỉ mới"
                        : "Thay đổi địa chỉ",
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
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Địa chỉ",
                                    style: AppText.style.boldBlack14,
                                  ),
                                  SizedBox(
                                    height: Dimension.height4,
                                  ),
                                  BlocBuilder<EditAddressBloc,
                                          EditAddressState>(
                                      builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (state.address != null) {
                                          Navigator.of(context)
                                              .pushNamed(MapScreen.routeName,
                                                  arguments: LatLng(
                                                      state.address!.lat,
                                                      state.address!.lng))
                                              .then((location) {
                                            if (location != null) {
                                              MLocation mLocation =
                                                  location as MLocation;
                                              _addressController.text =
                                                  mLocation.formattedAddress;
                                              BlocProvider.of<EditAddressBloc>(
                                                      context)
                                                  .add(AddressChanged(
                                                      address: mLocation));
                                            }
                                          });
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed(MapScreen.routeName,
                                                  arguments: initLatLng)
                                              .then((location) {
                                            if (location != null) {
                                              MLocation mLocation =
                                                  location as MLocation;
                                              _addressController.text =
                                                  mLocation.formattedAddress;
                                              BlocProvider.of<EditAddressBloc>(
                                                      context)
                                                  .add(AddressChanged(
                                                      address: mLocation));
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
                                            return 'Vui lòng chọn địa chỉ!';
                                          }
                                          return null;
                                        },
                                        decoration:
                                            generateDisableTextDecoration(
                                                hintString: "Chọn địa chỉ"),
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Ghi chú",
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
                                          widget.deliveryAddress?.addressNote ??
                                              "",
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      style: AppText.style.regularBlack14,
                                      decoration: generateTextDecoration(
                                          hintString:
                                              "Thông tin thêm về địa chỉ"),
                                      maxLines: 2,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_nameFocusNode);
                                      },
                                      onChanged: (value) {
                                        BlocProvider.of<EditAddressBloc>(
                                                context)
                                            .add(AddressNoteChanged(
                                                addressNote: value));
                                      },
                                    );
                                  }),
                                  SizedBox(
                                    height: Dimension.height16,
                                  ),
                                  Text(
                                    "Người nhận",
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
                                      style: AppText.style.regularBlack14,
                                      decoration: generateTextDecoration(
                                          hintString: "Nguyen Van A"),
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_nameFocusNode);
                                      },
                                      validator: (value) {
                                        if (!isNameValid(value ?? "")) {
                                          return 'Xin hãy nhập tên người nhận.';
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
                                    "Số điện thoại",
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
                                          hintString: "0123456789"),
                                      onFieldSubmitted: (_) {
                                        _submitForm(state);
                                      },
                                      maxLength: 11,
                                      validator: (value) {
                                        if (!isPhoneValid(value ?? "")) {
                                          return 'Vui lòng nhập đúng số điện thoại';
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
                                  EditAddressState>(builder: (context, state) {
                                return ElevatedButton(
                                    onPressed: () => _submitForm(state),
                                    style: _roundedButtonStyle,
                                    child: Text(
                                      "Lưu",
                                      style: AppText.style.regularWhite16,
                                    ));
                              }))
                    ],
                  ),
                ),
              ],
            )));
  }

  void _submitForm(EditAddressState editAddressState) {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(DeliveryAddress(
          address: editAddressState.address!,
          addressNote: editAddressState.addressNote,
          nameReceiver: editAddressState.nameReceiver,
          phone: editAddressState.phone));
    }
  }
}

mixin InputValidationMixin {
  bool isAddressValid(String address) => address.isNotEmpty;
  bool isNameValid(String name) => name.isNotEmpty;

  bool isPhoneValid(String phone) {
    RegExp regex = RegExp(
        r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$');
    return regex.hasMatch(phone);
  }
}
