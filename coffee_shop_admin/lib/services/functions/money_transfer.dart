import 'package:intl/intl.dart';

class MoneyTransfer {
  static final _oCcy = NumberFormat("#,##0.00", "en_US");

  static String transferFromDouble(double value) {
    String currency = _oCcy.format(value);
    if (currency.contains(".00")) {
      if (currency != "0.00") {
        return currency.substring(0, currency.length - 3);
      } else {
        return "0";
      }
    } else if (currency[currency.length - 1] == '0') {
      return currency.substring(0, currency.length - 1);
    } else {
      return currency;
    }
  }
}
