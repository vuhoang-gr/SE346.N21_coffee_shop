import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:coffee_shop_staff/utils/validations/validator.dart';
import 'package:coffee_shop_staff/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';

// ignore: must_be_immutable
class CustormTextForm extends StatefulWidget {
  CustormTextForm(
      {super.key,
      required this.controller,
      this.validator,
      this.verifiedCheck = false,
      this.secure = false,
      this.margin,
      this.label,
      this.readOnly = false,
      this.haveDatePicker = false,
      this.prefixIcon,
      this.onChanged,
      this.canCancel = false});

  final TextEditingController controller;
  final Validator? validator;
  final bool verifiedCheck;
  final bool secure;
  final EdgeInsets? margin;
  final String? label;
  final bool haveDatePicker;
  bool readOnly;
  final Icon? prefixIcon;
  final void Function(String)? onChanged;
  final bool canCancel;

  @override
  State<CustormTextForm> createState() => _CustormTextFormState();
}

class _CustormTextFormState extends State<CustormTextForm> {
  late bool _isValidate;
  late DateTime selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void onCancel() {
    setState(() {
      widget.controller.text = "";
      if (widget.onChanged != null) {
        widget.onChanged!("");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.validator != null) {
      _isValidate = widget.validator!.validate(widget.controller.text);
    } else {
      _isValidate = false;
    }

    if (widget.haveDatePicker) {
      DateTime getDate;
      try {
        getDate = DateFormat('dd/MM/yyyy').parse(widget.controller.text);
      } catch (e) {
        print('Wrong type of datetime');
        getDate = DateTime(2000, 1, 1);
      }
      selectedDate = getDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 5,
            blurRadius: 6,
          ),
        ],
      ),
      margin: widget.margin,
      child: TextFormField(
        readOnly: widget.haveDatePicker ? true : widget.readOnly,
        style: AppText.style.regularWhite16.copyWith(
          color: AppColors.blackColor,
        ),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          if (!widget.verifiedCheck) return;
          if (widget.validator!.validate(value)) {
            setState(() {
              _isValidate = true;
            });
          } else {
            setState(() {
              _isValidate = false;
            });
          }
        },
        controller: widget.controller,
        validator:
            widget.validator != null ? widget.validator!.validator : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: widget.secure,
        enableSuggestions: !widget.secure,
        autocorrect: !widget.secure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: widget.label,
          contentPadding: EdgeInsets.symmetric(
            horizontal: Dimension.getWidthFromValue(20),
            vertical: Dimension.getHeightFromValue(10),
          ),
          alignLabelWithHint: false,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.haveDatePicker
              ? TouchableOpacity(
                  unable: widget.readOnly,
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Icon(Icons.calendar_month),
                )
              : widget.canCancel && widget.controller.text.isNotEmpty
                  ? TouchableOpacity(
                      unable: widget.readOnly,
                      onTap: onCancel,
                      child: Icon(Icons.cancel),
                    )
                  : _isValidate
                      ? Icon(Icons.check)
                      : null,
          suffixIconColor: widget.haveDatePicker
              ? AppColors.greyTextColor
              : widget.canCancel
                  ? AppColors.redColor
                  : AppColors.greenColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.blackColor,
              width: 0.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.blackColor,
              width: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
