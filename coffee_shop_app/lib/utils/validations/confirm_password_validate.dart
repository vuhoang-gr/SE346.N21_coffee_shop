import 'package:coffee_shop_app/utils/validations/validator.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordValidator extends Validator {
  TextEditingController oldPassword;
  ConfirmPasswordValidator({required this.oldPassword});
  @override
  bool validate(String? value) {
    if (value == null || value.isEmpty) return false;
    RegExp exp = RegExp(r'^(?=.*[a-z])(?=.*?[0-9]).{8,}$');
    if (exp.hasMatch(value) && value == oldPassword.text) return true;
    return false;
  }

  @override
  String? validator(String? value) {
    if (!validate(value)) {
      return "Xác nhận mật khẩu sai!";
    }
    return null;
  }
}
