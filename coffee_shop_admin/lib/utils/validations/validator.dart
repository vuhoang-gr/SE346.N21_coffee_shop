abstract class Validator {
  bool validate(String? value);
  String? validator(String? value);
}

class NullValidator extends Validator {
  @override
  bool validate(String? value) {
    return value != null && value.isNotEmpty;
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

class PriceValidator extends Validator {
  @override
  bool validate(String? value) {
    if (value == null || value.isEmpty) return false;
    return int.tryParse(value) != null && int.parse(value) >= 0;
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

class PercentValidator extends Validator {
  @override
  bool validate(String? value) {
    if (value == null || value.isEmpty) return false;
    return int.tryParse(value) != null &&
        (0 <= int.parse(value) && int.parse(value) <= 100);
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
