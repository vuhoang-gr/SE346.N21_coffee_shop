import 'package:coffee_shop_staff/utils/validations/validator.dart';

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
      return "This field cannot be empty!";
    }
    if (!validate(value)) {
      return "Wrong type!";
    }
    return null;
  }
}
