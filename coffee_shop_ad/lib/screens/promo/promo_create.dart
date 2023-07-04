import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_event.dart';
import 'package:coffee_shop_admin/services/models/promo.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/validations/validator.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:coffee_shop_admin/widgets/global/textForm/custom_text_form.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class CreatePromoScreen extends StatefulWidget {
  static const routeName = "/create_promo";
  final List<String> existCodeList;
  const CreatePromoScreen({super.key, required this.existCodeList});
  @override
  State<CreatePromoScreen> createState() => _CreatePromoScreenState();
}

class _CreatePromoScreenState extends State<CreatePromoScreen> {
  TextEditingController codeController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController percentController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  bool _forNewCustomer = false;
  bool _isKeyboardOpened = false;

  List<bool> _selectedStores = [];

  @override
  void initState() {
    super.initState();
    _selectedStores = List<bool>.generate(Promo.allStores.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.existCodeList);
    _isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 0;

    // ignore: no_leading_underscores_for_local_identifiers
    bool _validateData() {
      String code = codeController.text;
      if (code.isEmpty || widget.existCodeList.contains(code.toUpperCase())) {
        return false;
      }

      String percent = percentController.text;
      if (percent.isEmpty || int.tryParse(percent) == null || int.parse(percent) < 0 || int.parse(percent) > 100) {
        return false;
      }

      if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
        return false;
      }
      DateTime startDate = DateTime.parse(startDateController.text);
      DateTime endDate = DateTime.parse(endDateController.text);
      if (endDate.isBefore(startDate) || startDate.isAtSameMomentAs(endDate)) return false;

      String miPrice = minPriceController.text;
      if (miPrice.isEmpty || int.tryParse(miPrice) == null) {
        return false;
      }
      String mxPrice = maxPriceController.text;
      if (mxPrice.isEmpty || int.tryParse(mxPrice) == null) {
        return false;
      }
      if (int.parse(mxPrice) < int.parse(miPrice)) return false;

      return true;
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _hanldeCreatePromo() async {
      if (!_validateData()) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          confirmBtnText: "Ok",
          confirmBtnColor: AppColors.blueColor,
          confirmBtnTextStyle: AppText.style.regularWhite16,
          text: 'Invalid data!',
        );
        return;
      }

      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Creating your new promo...',
      );

      String code = codeController.text.toUpperCase();
      double percent = double.parse(percentController.text) / 100.0;
      String description = descriptionController.text;
      Timestamp startDate = Timestamp.fromDate(DateTime.parse(startDateController.text));
      Timestamp endDate = Timestamp.fromDate(DateTime.parse(endDateController.text));
      int mi = int.parse(minPriceController.text), mx = int.parse(maxPriceController.text);

      try {
        List<dynamic> choosedStore = [];
        for (int i = 0; i < _selectedStores.length; i++) {
          if (_selectedStores[i]) {
            choosedStore.add(Promo.allStores[i].id);
          }
        }
        await promoReference.doc(code).set({
          "dateStart": startDate,
          "dateEnd": endDate,
          "description": description,
          "forNewCustomer": _forNewCustomer,
          "minPrice": mi,
          "maxPrice": mx,
          "percent": percent,
          "products": [],
          "stores": choosedStore,
        }).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          BlocProvider.of<PromoBloc>(context).add(FetchData());

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Completed Successfully!',
            confirmBtnText: "Ok",
            confirmBtnColor: AppColors.blueColor,
          );
        });
      } catch (e) {
        print("Something wrong when create new promo");
        print(e);
      }
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: WillPopScope(
              onWillPop: () async {
                Navigator.pop(context, false);
                return false;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppBar(
                    leading: Text(
                      "New Promo",
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Dimension.height16,
                                          right: Dimension.height16,
                                          top: Dimension.height16,
                                          bottom: Dimension.height16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              CustormTextForm(
                                                controller: codeController,
                                                validator: CodeValidator(codes: widget.existCodeList),
                                                verifiedCheck: true,
                                                label: 'Promo code',
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              CustormTextForm(
                                                controller: percentController,
                                                validator: PercentValidator(),
                                                verifiedCheck: true,
                                                label: 'Percent (%)',
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.05),
                                                        spreadRadius: 5,
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                  height: Dimension.height12 * 13,
                                                  width: double.maxFinite,
                                                  child: TextField(
                                                    controller: descriptionController,
                                                    scrollPadding: EdgeInsets.only(bottom: Dimension.height16),
                                                    textAlignVertical: TextAlignVertical.top,
                                                    expands: true,
                                                    maxLength: 200,
                                                    style: AppText.style.regularWhite14.copyWith(
                                                      color: AppColors.blackColor,
                                                    ),
                                                    decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.symmetric(
                                                          horizontal: Dimension.getWidthFromValue(20),
                                                          vertical: Dimension.getHeightFromValue(10),
                                                        ),
                                                        hintText: 'Description',
                                                        hintStyle: AppText.style.regularGrey14,
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: AppColors.blackColor,
                                                            width: 0.4,
                                                          ),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: AppColors.blackColor,
                                                            width: 0.2,
                                                          ),
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(4),
                                                            borderSide:
                                                                const BorderSide(color: AppColors.greyBoxColor))),
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: null,
                                                  )),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                      value: _forNewCustomer,
                                                      onChanged: (val) => setState(() {
                                                            _forNewCustomer = val as bool;
                                                          })),
                                                  Text("For new customer?")
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              DateTimePicker(
                                                type: DateTimePickerType.dateTimeSeparate,
                                                controller: startDateController,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                icon: Icon(Icons.event),
                                                style: AppText.style.regularBlack14,
                                                dateLabelText: 'Start Date',
                                                timeLabelText: "Time",
                                                selectableDayPredicate: (date) {
                                                  if (date.weekday == 6 || date.weekday == 7) {
                                                    return false;
                                                  }
                                                  return true;
                                                },
                                              ),
                                              DateTimePicker(
                                                type: DateTimePickerType.dateTimeSeparate,
                                                controller: endDateController,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                icon: Icon(Icons.event),
                                                dateLabelText: 'End Date',
                                                style: AppText.style.regularBlack14,
                                                timeLabelText: "Time",
                                                selectableDayPredicate: (date) {
                                                  if (date.weekday == 6 || date.weekday == 7) {
                                                    return false;
                                                  }
                                                  return true;
                                                },
                                              ),
                                              SizedBox(height: 12),
                                              CustormTextForm(
                                                controller: minPriceController,
                                                validator: PriceValidator(),
                                                verifiedCheck: true,
                                                label: 'Min Price (VND)',
                                              ),
                                              SizedBox(height: 12),
                                              CustormTextForm(
                                                controller: maxPriceController,
                                                validator: PriceValidator(),
                                                verifiedCheck: true,
                                                label: 'Max Price (VND)',
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //stores
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
                                    Text(
                                      "Stores",
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
                                                  _selectedStores[index] = !_selectedStores[index];
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                          value: _selectedStores[index],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _selectedStores[index] = value as bool;
                                                            });
                                                          },
                                                        ),
                                                        Expanded(
                                                            child: Text(Promo.allStores[index].sb,
                                                                style: AppText.style.regularBlack14)),
                                                        SizedBox(
                                                          height: Dimension.height20,
                                                          width: Dimension.width20,
                                                          child: IconTheme(
                                                            data: IconThemeData(
                                                              size: Dimension.width20,
                                                              color: AppColors.blueColor,
                                                            ),
                                                            child: const FaIcon(FontAwesomeIcons.store),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: Dimension.height8,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        separatorBuilder: (_, __) => const Divider(
                                              thickness: 2,
                                              color: AppColors.greyBoxColor,
                                            ),
                                        itemCount: _selectedStores.length),
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
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dimension.width16, vertical: Dimension.height8),
                                child: ElevatedButton(
                                    onPressed: _hanldeCreatePromo,
                                    style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(0),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(Dimension.height20),
                                        )),
                                        backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor)),
                                    child: Text(
                                      "Create Promo",
                                      style: AppText.style.regularWhite16,
                                    )))
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

class CodeValidator extends Validator {
  List<String> codes;
  static final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  CodeValidator({required this.codes});

  @override
  bool validate(String? value) {
    if (value == null || value.isEmpty) return false;
    if (value.contains(' ')) return false;
    if (!validCharacters.hasMatch(value)) return false;
    if (codes.contains(value)) return false;
    if (codes.contains(value.toUpperCase())) return false;
    if (codes.contains(value.toLowerCase())) return false;
    return true;
  }

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty!";
    }
    if (!validate(value)) {
      if (codes.contains(value) || codes.contains(value.toUpperCase()) || codes.contains(value.toLowerCase())) {
        return "Code existed!";
      }
      return "Wrong type!";
    }
    return null;
  }
}
