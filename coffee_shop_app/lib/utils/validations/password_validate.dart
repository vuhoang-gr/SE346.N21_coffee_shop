import 'package:coffee_shop_app/utils/validations/validator.dart';

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
      return "8 characters, at least 1 letter, 1 number.";
    }
    return null;
  }
}
