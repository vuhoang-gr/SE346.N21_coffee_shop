import 'package:coffee_shop_staff/utils/validations/validator.dart';

class PasswordValidator extends Validator {
  @override
  bool validate(String? value) {
    if (value == null || value.isEmpty) return false;
    RegExp exp = RegExp(r'^(?=.*[a-z])(?=.*?[0-9]).{8,}$');
    if (exp.hasMatch(value)) return true;
    return false;
  }

  @override
  String? validator(String? value) {
    if (!validate(value)) {
      return "Ít nhất 8 ký tự gồm một chữ và một số.";
    }
    return null;
  }
}
