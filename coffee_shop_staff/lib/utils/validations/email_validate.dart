import 'package:coffee_shop_staff/utils/validations/validator.dart';

class EmailValidator extends Validator {
  @override
  bool validate(String? value) {
    if (value == null) return false;
    RegExp exp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return exp.hasMatch(value);
  }

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Không được bỏ trống trường này!";
    }
    if (!validate(value)) {
      return "Sai định dạng!";
    }
    return null;
  }
}
