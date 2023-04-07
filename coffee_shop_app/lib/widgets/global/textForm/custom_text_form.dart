import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/utils/validations/validator.dart';
import 'package:flutter/material.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';

class CustormTextForm extends StatefulWidget {
  const CustormTextForm(
      {super.key,
      required this.controller,
      this.validator,
      this.verifiedCheck = false,
      this.secure = false,
      this.margin,
      this.label});

  final TextEditingController controller;
  final Validator? validator;
  final bool verifiedCheck;
  final bool secure;
  final EdgeInsets? margin;
  final String? label;

  @override
  State<CustormTextForm> createState() => _CustormTextFormState();
}

class _CustormTextFormState extends State<CustormTextForm> {
  late bool _isValidate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.validator != null) {
      _isValidate = widget.validator!.validate(widget.controller.text);
    } else {
      _isValidate = false;
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
        style: AppText.style.regularWhite16.copyWith(
          color: AppColors.blackColor,
        ),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: (value) {
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
          suffixIcon: _isValidate ? Icon(Icons.check) : null,
          suffixIconColor: AppColors.greenColor,
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
