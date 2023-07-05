import 'package:coffee_shop_app/utils/validations/validator.dart';

class PhoneValidator extends Validator {
  @override
  bool validate(String? value) {
    if (value == null) return false;
    RegExp exp =
        RegExp(r'^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
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
